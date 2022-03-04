class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.0.1",
      revision: "6e9dd49b5da9c045125078bb95be9f0dc27e8263"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3db689e1bd6e80086c603deca2fd646e37c958d7d2601543d8ecdf8dfc4b56e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d2fc43a1560b49e43807c9b68174a09d031c2b8fe72aa73e287e393222c35f3"
    sha256 cellar: :any_skip_relocation, monterey:       "917e4cd48f041113965bdca8d9f247af63754214e6e99aef40299faef4368f5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cda6e8ff510e97ffc140ef7f298ef73ac9e2df7464f566dfc8b1973fe02aaa4"
    sha256 cellar: :any_skip_relocation, catalina:       "7f64f6382edfddfb557c61780b2dfd3200badad8699c7689599b307f4856ef36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a35fa258505be20a284fa4e6cb699a2e7372aaac4eede81ac7a29fe69a99848"
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
