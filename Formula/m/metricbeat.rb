class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.4",
      revision: "5449535b768a9308714a63dc745911c924da307b"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ee09fa05696e11e055f1d3f366caf073e7e92707077a60bd31c9d2b56f389f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "418b104030cc5c53fa3c211848e50431374f971d2093ec4b6a60598220ad37f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27d40e5ed66fbc6433db73ce006b5900b7f43a9c70590c082a6aabe28337a3c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "699242e57c8102f12cb29de22ee4410dc8543847efcf23905090027d62fc6d71"
    sha256 cellar: :any_skip_relocation, ventura:       "79d1e5eb20df23bbb08186c495491ba18362380e4727d57b2e2ffe2e56a43d71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b3767ac6895381ba9fbe605a88acb0151a516cad8a556641d4636ac8610a71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25e74b9a48f998cfa3a4b9437749cd599f7083ac5d1a34bdd26646773e977cd5"
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
