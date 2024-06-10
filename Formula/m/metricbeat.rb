class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.14.0",
      revision: "de52d1434ea3dff96953a59a18d44e456a98bd2f"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f319657bae19a987d8a3746ba3c0cd3a0e803e13ad1c72190531f1dfbb107e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07b69514fd9b7f98d6228b482450ae65d438dbc3651db64eb3b53437c32b2247"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38ad9ef9105373bf020a25021e5d2f1c176cb973b0a58ab4ad2aeac29cfae27d"
    sha256 cellar: :any_skip_relocation, sonoma:         "0037937def3636e73eca4ba2f45d47f0142d679694c548bd18be84a41c283a3d"
    sha256 cellar: :any_skip_relocation, ventura:        "8b808d70c112f4d37fc576707a6ce5d5809a964730d5dbb1d40e745d920dfe1e"
    sha256 cellar: :any_skip_relocation, monterey:       "9b03882d71ecd20247363950fc187f327bf8cd8bdcc3cdeb6c45da630d41c4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17bc0d921bb02fc600c7a58005fe8d4e9e86b92996c88bfc97ef45e80e17e020"
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
