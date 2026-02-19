class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.3.0",
      revision: "0f4fc63162db855e0a1c5f0ec5894a8939e31d80"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "312a6030e452555b24584f0f55f562156488da4ce9691cd59f7f9dcfa2244249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a3ae140212736d60075d62a01c8779cdbe8b6d4ac3c1577bf188ef4ca89ef51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99070f9aba4146aee4124d351b3e2ff747b4c8397ab5dd5d649eba51ce200d18"
    sha256 cellar: :any_skip_relocation, sonoma:        "95c5019072b5779bd011aab42a2bc7ed16daefca1741943f80bd99614e19047d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93b70862242240ce7b1d85f324bd4079966be9ed7b1a61dcf2f8d15cbdda837c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d4e6b6fd811a9d80683642e791adb60492c6b1dab197b1a5692e3f50b9e2a99"
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
