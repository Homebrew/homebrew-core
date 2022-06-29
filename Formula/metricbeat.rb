class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.0",
      revision: "0ee1ead440422ce0eafb95031c0de20180d75a49"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf2cb59b3d4ee97bb1137b960573cc3c0b8d95fa320c90fbddc263f3a2a8bd9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e232d8011848b583bf968d15b03da05dd208fc55f5a44714e0c4ece393c24e7"
    sha256 cellar: :any_skip_relocation, monterey:       "5b937a813564e2001dfae9cbadc96290bc5ab63b5faf5239c3ea2c4977ed301c"
    sha256 cellar: :any_skip_relocation, big_sur:        "492ebe6f0fd0913ae32e81b80927a333808410ecd2426aa895d53eaf8a99ee39"
    sha256 cellar: :any_skip_relocation, catalina:       "603d560f94c234acdf52b231ea2081a249cb5f489ee83a1c3b6ea13731392f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25e1004b505439a47802c45e3e332de2d325203a23270d64df762026a48e7a2a"
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
