class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.2",
      revision: "45ad74566fce5c8c6f1df8a6b90cfa76310cfcfb"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4075db551090e4fa9881e4a1aff31e76035baf96b4cdec5cb2aa92a2ba1e4443"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ea89753d75c6a371673baf9a2ac716ad6f9ee42645a0bc43e5fed8488ce1b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d0011be3d926db21f5abac245d46ea4f01b3d3b01095daeaaa682fabf142251"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfa9d188fd6b63d89086afbd7cde5937fdc96efe649c3f5e8410f0dd0fedfbc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b98b6afdaea6a0b8b041d0f854e514bfc2fb1ec310ef2e43ba94f88d96388c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0df5ed5f6854f35e58be0ae7178079eee3c535e1394cddc969dc78796e822d48"
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
