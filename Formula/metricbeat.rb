class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.7.0",
      revision: "a8dbc6c06381f4fe33a5dc23906d63c04c9e2444"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "323143cf6565cda892eb4762d3259f30b09f1b56ae37c4196a97ecde4a12a280"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a745e19760149f37af3b61111795d8459767d358914fd08a6782d0516b261336"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b69e6ab21dbdbb467e1c337984b37a89faf51aaa4c34cd5b1907ef86d2e1e6c4"
    sha256 cellar: :any_skip_relocation, ventura:        "8e9e5bd70265a5d14f79bb42805ce3bb7201b9359b1a7bfe94fdfb5661be0ab9"
    sha256 cellar: :any_skip_relocation, monterey:       "ce32ee89fc839a051664efbaf99a5eb6556400f1cf1bdf79dc0e617d122bcd6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "96701f083ff426182a769e4fa2b16c49431bc76374333154d6501a9738e23a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4449e56961744f2bc0506c89e7c20e0f696706217d7cd72636737062447c43bc"
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

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
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
