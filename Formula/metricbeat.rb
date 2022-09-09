class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.5.2",
      revision: "1ebd0940bd56943642ea8d63d1fe8227f86e7435"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bdc88210752ed7d6b292b88f1319c8091225385ad563f34cd73c9a471120c4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd6b7018ee96c34de9fbd8c14b308316f08cda4c55e705c1319c6bdffb3e0376"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6bb9b3e8d1cffa3f33183092a8e98856197ca18315a06f85f2bcf5aa008037b"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a7f5fa9b7a931dcc6fb536a34bc51d32dadc7f5c9633fd36d008e6f2e6c86d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a64c858130de1607416a252a4667fb516393801010a0ad813c0b728118d92de2"
    sha256 cellar: :any_skip_relocation, catalina:       "7d60e8f7c6f9b1329ef1be80d4251cd532614716328663085df584432bb81a7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3ade0489251aaf3edb6d044103b2eb5663f1a8c350c370c7d985a7eb26d133d"
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
