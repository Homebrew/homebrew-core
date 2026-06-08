class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.4.2",
      revision: "e98b93df5a916738f04a338ea2ddcf53ebd0bc0b"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4efb408c8a2ff57f892e1e2f90762179992983580fc52a89c8f05905c17c793a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60da0e47ead9822363ed839562dbbe9af9a1d39c8eddf960ead727d4e31d044a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf235be306335e64197c238567aba16b910ba052ddea92a26b6661a76c572eb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3444fabf58bd3b56b5e384189e30212b423dff91eded4e809dc099860f5d231f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6e9841e6f56ee0671269bae1c0365acbff10fd71eb411abb731fafdcff1878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b8025bf457537c19e42815671795b4ed611f6ce509527fd915d95166b8feb9"
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
