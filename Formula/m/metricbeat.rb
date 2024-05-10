class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.13.3",
      revision: "79b1528b7bfbf5152041db8f4ab497af6afa06e2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00bea25a8de0019e20153349332ebfff20f5407859ab36e7fe843c7cd601d2c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a0689f05760f5418b42e1b751aeace4e41fbca182706970cbe67441befd8914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93860a3f1e3f94e97768711915a8de3b64c5610f60452254fd6f960156fe1b2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ac31cab91134141c87d24da4e029260dc8d0841edb09e28f459adcad1cadf8f"
    sha256 cellar: :any_skip_relocation, ventura:        "2446c39417c51b0d79ad83d9c1868421fe8c85734078bf96543835f154841e93"
    sha256 cellar: :any_skip_relocation, monterey:       "fdb9d9c1ebf7c50076b18f9ff29b346a471b73760f4e77526425f8c401a3d136"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c73ddb3c26f29c9b576700fce22ae65991a5e36e5e04f2a2ee9fa57e35923c1"
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
