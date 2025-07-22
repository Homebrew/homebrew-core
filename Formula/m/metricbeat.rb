class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v9.0.4",
      revision: "7f7d7133471388154c895cf8fc6b40ae6d6245e2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57098d4771f22ca94dc7d03b93a58444846e8377c88509c2d0b2ef9b20a86c39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90518e658f303407343d6c0d4b670b740ea53901adc6bf5fb1d064a9df07c272"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1033e3694a4383e83906eb91cea4584e9fba93fdd2f12434cf8507a77d0be46"
    sha256 cellar: :any_skip_relocation, sonoma:        "93c2f1a748e33ba0af33fa68c77775b96d1c1b102ee88e24bc7949b6497aeaad"
    sha256 cellar: :any_skip_relocation, ventura:       "3f8dba8c77a5738f1854331cdbadf57a1043c680e13595e84af338cfd1b451dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e1a62e222270c1a0009a631b9016e96c354d8640ef9f5f6331c4cfe63f2fbc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f789b7162e1fa9f3b0a4d06b5083b2fe378a3ebba38f8acfe0992b9bf3cd3c5"
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
