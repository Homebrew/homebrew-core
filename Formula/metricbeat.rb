class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.0",
      revision: "da4d9c00179e062b6d88c9dbe07d89b3d195d9d0"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "801fa46de2cff7e89ad9185d292724c7ecbc90f8443d414ce9df2a0d12a8c743"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdc106afca534d03c407c606bc0b80fe218e3b5d88e6eea1cc7a857b138a9177"
    sha256 cellar: :any_skip_relocation, monterey:       "09e4ab270c21d34455306942c63a8e2f58e328d9ca94c798a524c474921e09c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc0ed9f8bcf3c8470650e920549d42529fe2c02cf399ca7e148e5a2804f11c64"
    sha256 cellar: :any_skip_relocation, catalina:       "011ef9edf4ff4e668b777d73e921eb09c52e676c324e72f8ce48874e432b13e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2223094b8dce1d2d4f7ebb67c438f150d19c64761675f630c36f3d0a45a7e2b"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

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
