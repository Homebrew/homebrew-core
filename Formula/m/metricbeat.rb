class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.17.1",
      revision: "424070e87d831d2d66a7514e1c1120ad540a86db"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1755a42d6631047c7bac9181320810c60b32b4dcc0ebe7df059e6ea6a1581a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ddb603ca8795856a865778659073d1e266344f626449948b223ef7f9df97f6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce096dfef6503e6139979053ff40bf16821a8d1ae34974ff2ad9e91aebf79148"
    sha256 cellar: :any_skip_relocation, sonoma:        "b928d0dbc19259b93f2459aef85dd1c15f7dc41e67f87b08a798fee1c7e7a887"
    sha256 cellar: :any_skip_relocation, ventura:       "ebe9d3b6374645af2504008ed87256f925294239bb4a172ada40980231c95c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe398358324d19f3ea8627807e080d525e3cfe79c5d53583a2629ed1631e71f7"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  def install
    # remove non open source files
    rm_r("x-pack")

    cd "metricbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mg.Deps(CollectDocs, FieldsDocs)", ""

      system "mage", "-v", "build"
      system "mage", "-v", "update"

      pkgetc.install Dir["metricbeat.*", "fields.yml", "modules.d"]
      (libexec/"bin").install "metricbeat"
      prefix.install "build/kibana"
    end

    (bin/"metricbeat").write <<~SH
      #!/bin/sh
      exec #{libexec}/bin/metricbeat \
        --path.config #{etc}/metricbeat \
        --path.data #{var}/lib/metricbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/metricbeat \
        "$@"
    SH

    chmod 0555, bin/"metricbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"metricbeat", "completion", shells: [:bash, :zsh])
  end

  service do
    run opt_bin/"metricbeat"
  end

  test do
    (testpath/"config/metricbeat.yml").write <<~YAML
      metricbeat.modules:
      - module: system
        metricsets: ["load"]
        period: 1s
      output.file:
        enabled: true
        path: #{testpath}/data
        filename: metricbeat
    YAML

    (testpath/"logs").mkpath
    (testpath/"data").mkpath

    pid = spawn bin/"metricbeat", "--path.config", testpath/"config", "--path.data", testpath/"data"

    sleep 15

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("metricbeat-*.ndjson") do |file|
      s = JSON.parse(file.read.lines.first.chomp)
      assert_match "metricbeat", s["@metadata"]["beat"]
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
