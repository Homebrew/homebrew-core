class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.5.2",
      revision: "8f4fe1e5dec067a139dce33d3af88c24b58c3660"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84ce5dc868f3aae4c86d89832e8bb920ea188734bbfc5a8d9920be0fe06ac500"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c7093dadb6e51f448373b48665ff03b290c8c2287f24c24ab27931577c50255"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7969d54f0e06b0627c83a50234d97fe0ebf17b5d6fb5bd2b28488be3bfd662fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "070e6ef5cbd530e23c872e9722d4f76298a5531cd8a72c0b272f70dc206f0a66"
    sha256 cellar: :any,                 arm64_linux:   "e577e5362e9a8b70a7def1d73c068bcb6390d4ea864b7baabf42760f5c180c00"
    sha256 cellar: :any,                 x86_64_linux:  "f7e19c9d06346d735478b3e806e00a0ac29c1b598a179b543c9a328e4c2b5de1"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
