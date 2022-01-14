class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.3",
      revision: "d420ccdaf201e32a524632b5da729522e50257ae"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88345b5f44fa74d9bc69bf49ddc3a433a29b5c8e3cb35219025ba439adc73e05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dd086040e97fcdf582b95e1f5f1c620ef1e6049eb734bb5014cdb2e043d4cab"
    sha256 cellar: :any_skip_relocation, monterey:       "1c5161a6887019e14401d20191be5985719eb558fdd7c0b7c15401531349b694"
    sha256 cellar: :any_skip_relocation, big_sur:        "779503e17d193d9717400f353657aba942fb901d525b3f1cb787dfd84423b684"
    sha256 cellar: :any_skip_relocation, catalina:       "22089c540475269947777777e93648f559a334c22659c98cc8906ff7c1b44b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df29cbb91daa55b7ee40f93c3f40ff0ea58b566cd675df988bbe22d83e9f15b1"
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
