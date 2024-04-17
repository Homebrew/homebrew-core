class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.2",
      revision: "d41b4978ea7b4d7c6020b47ffd8a3b8642531fe3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81241f8423115db6a42b291a74e11becf20c7ea452dceab971d5ad14886f2321"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19b60ba77d32e62240fe0472f02127d3cfed562f18b71216aa5bb967606583bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a4e5b4d51bd4b2e229620c96f236522e8f74348b02e4856878c68cafc18cb29"
    sha256 cellar: :any_skip_relocation, sonoma:         "57b33babdb4a43aa63d7f3a42845aaba7e1a4e8549169c9790e6d6d73a912317"
    sha256 cellar: :any_skip_relocation, ventura:        "85112502451e66f76c98e3dad5115414bd68375e273551808db0843b13818ec3"
    sha256 cellar: :any_skip_relocation, monterey:       "8e15fdac421d400abbb625a41e4c0cd847aeb586ce36104d9098eb3a74a29217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55d571a17863424d0ec1c1fbb818cb288fbe665f93b287d09ae6ce97389d3fd0"
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
