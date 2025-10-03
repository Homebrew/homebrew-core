class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.1.4",
      revision: "c50e2cc4adfaed4367b3fba44d27db0222123cec"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ecf1f7a57fa17406012c321ffe9ab16710664c4614d61712162f99fe02244b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa6b5b1a1049b690de04cc0bd84276c12fc5de6314b738521113b4f11af810d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "564e2f32c016e01a7ab47b04ccb182d3a881ad02d4184dc88ddf511c0f1e8a02"
    sha256 cellar: :any_skip_relocation, sonoma:        "a084b3b5fa536865c512073af08534f244c92e8fb2ad070b339ae1f8ffd67eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77c452f94c1bf829218e2342e66266aedd7de67604a2dfe8be5262216f1245dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "214deb692c9a7caeffa170d57b3f7108bf7eb803dc7f0e8ab4e4c1385d3cbf7d"
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
