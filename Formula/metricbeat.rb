class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f762a82630b442ceccb1f3575abbb93b98ffc7992ad95caf27a4a1e8b2ba1e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c95bbff37a72cbf0cd6aa4126e6ec50fe1879593e9b3e9378d4b6f894595e766"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ed0e2f1671cb5e0c5252363613a8f566d743c6a56e0161aeac6888d65ac3ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "470635adc5d8c1ba9cb3e669f6bfe6d31f6a71b112cf96992d6be1b25b8959a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "97c8e431f6c762fef99170922e9c2f59a9e153c5f77eda3d731215975d41ecf0"
    sha256 cellar: :any_skip_relocation, catalina:       "6e243ff03b3443faea6be93dcc726d7f8553e8c85e73dfc17de61f6125540138"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dd2fad647ca85a7d8066c118351f4161d2c1f0e7d6d3d81861a89902d400243"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"metricbeat").install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    EOS
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~EOS
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    EOS

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    fork do
      exec bin/"metricbeat", "-path.config", testpath/"config", "-path.data",
                             testpath/"data"
    end

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  end
end
