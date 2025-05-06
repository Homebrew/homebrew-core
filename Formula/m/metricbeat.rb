class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.0",
      revision: "42a721c925857c0d1f4160c977eb5f188e46d425"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bcded2d30e3f47c90437a8f96e3e41f6c13ca01020aba09108538ce2fecb94c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b787f0cbd00af0f48a97b0f0c65d32f4e0dd2ab91d27d5e5db439016cb88c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e3e96f0f955fdaed4d8e37268bd9ad5bf2eb135186bcf6ca05d1bb59b08eb2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d41d8ebc223203724a8ef4f69249c8995c242a43c42c7f8009155e7de4e311e0"
    sha256 cellar: :any_skip_relocation, ventura:       "ccfdcc153df244599fb4d722df5483f8a1941e567805ef8e4219eb8e6a153c90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c62afd760e6bba99e05911881f44d5192ea2874872ebb52bc5e92b08c26b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "156c5e3a1b01dfc1b19ae3f650beb6fa5bbd2316d7fb0dcea3977bf5490aba3b"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    SH

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~YAML
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    YAML

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    pid = spawn bin/"metricbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
