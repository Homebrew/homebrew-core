class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.3",
      revision: "d9d2860c7593868e25d1b2da7da43793fe12c99e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c6fa0bd753c9f3a3afdafd3bd9f2367e24fdbd7e5d0e0704692b245e7e6206d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d39e5408971fdf3104c2e7705ad9993ed31435650e1ddef4c4593f866d2bd20a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7516c9f4150cd46d03ae6212332b601e9440210e1db4cca36fad960dbea4e174"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b1f19a35c600ae1d7f0d7fb8f1102a954258d35ec224d80d347469d1c373b30"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba25193f91a23fc12fc21140fca350c9f8a5115442b515ca1cea34d3a1ed5d4"
    sha256 cellar: :any_skip_relocation, ventura:       "e1b83cc1cb651d09532465250ffc126229586c84dd68ea79b3f8369256651f2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e2ea728f63856215b4a788a8a5983f926a157090837148d8402217e5efed89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb8ae33b6332e4592301e00811717c6e8632e259a86e5db3f43cfbaeb9d20b6e"
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
