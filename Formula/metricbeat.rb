class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.0",
      revision: "561a3e1839f1a50ce832e8e114de399b2bee2542"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ae2e5a0129f987d5c95c7d269c04f3f6c69b196db577f9f12d4945dd4d524cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d300cf38cd26c93b1c6e773c7aeb1d39e2fbfc099b52950f7f52dff28a2a5b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9789b025afdb9dbfac43808786cd1de3238dc391e2a9de0d52ed994a94438a3a"
    sha256 cellar: :any_skip_relocation, ventura:        "f36d4774412136d6a353c2f74a6ff6d3111a7d9b2ef708982be7d40e004b5cde"
    sha256 cellar: :any_skip_relocation, monterey:       "a204c61e1c305c69ac6590f2ed4d543264fce650db04560284306afb4f98aeef"
    sha256 cellar: :any_skip_relocation, big_sur:        "599dccd11ef18b6d38ae3803f228ab2991aed5c36028eb33ec38c98cb2a3d6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f3b0f75221bbd8c36bbf347b700659e2f282dde752bcbcde61278a15a4e31fc"
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
