class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.0",
      revision: "4bcd954491364231b14d7f340500441af2133209"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adeace687cd50ed5127a52a0050b506eae7d842aa047f2d30081baf249d4b077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5af70b9235f6a42fc09af933dd0467c6de39ec236435338d19fa4117b2015c7"
    sha256 cellar: :any_skip_relocation, monterey:       "a4f7f01d3c69b72ec56def0a652706739d4c86dd82709d305a28050b9cc8ead2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d151cc60e1989ab8d1e77624857be6e1d8db75541600540c03b90817c64d7a98"
    sha256 cellar: :any_skip_relocation, catalina:       "1bb19ca9e7a6cc1b51352490b808d07248c5e12b6106e600fca3c38d2aa9c9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc996a694e18f7f93970c778fdba3bde509cb8dce2c09b4ba5566c65486efcf"
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

    sleep 30
    assert_predicate testpath/"data/metricbeat", :exist?
  end
end
