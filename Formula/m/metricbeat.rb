class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.0",
      revision: "26aad5d437d592cea2d8d3e0b950f885ff47fe41"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b881336770da55c69c72ee3ae05081f1633e2ebcddbcf9ca8537ed472d932cc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91e8454878d2cbbce2e728e7367e0987ac63f1f32e66fdccfa7b8b9df3a49e50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f49101cd5e4bf042bf7a9ff5d0da8c229804b77f9ed535d727ff03d0ea5983a"
    sha256 cellar: :any_skip_relocation, sonoma:         "de13ac900f2b0431f744f7af8c689a41c7caaf04b4a3b1b9bd1816987e60f5c7"
    sha256 cellar: :any_skip_relocation, ventura:        "f2804bb00b1574375acc5b01a562b1de8e37d83b156897a0f34ce98fe060e102"
    sha256 cellar: :any_skip_relocation, monterey:       "472ab09087066f2595f85f42d621e037b929ea265e725c8b756707167cf200e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5b1bf39bdd81a7c631386d83d2bd86a305c929272a8514f0d663258d2c35983"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build

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
