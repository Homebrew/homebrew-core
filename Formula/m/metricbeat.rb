class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.10.4",
      revision: "10b198c985eb95c16405b979c63847881a199aba"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9c48d944793b23c76322de6c70300b3baee1f99651b3c8a12b7d81282c1f6c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6600a12de195b81bd4c761e7249c5b75310df647bce8bfd34d5057013e2f4f8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8e3c3b386e3deee735e8cacd397a10a3e2ee7fa2c45fe50b41ebd736f596d95"
    sha256 cellar: :any_skip_relocation, sonoma:         "35312fd50a6737cccf2207f80f087b4e7c5add4955a0c45d4ed9a7c479a6598e"
    sha256 cellar: :any_skip_relocation, ventura:        "bef04d198d63dd5298e289a71d82effbce837bb723a0023767e0420a21aafd84"
    sha256 cellar: :any_skip_relocation, monterey:       "04408ee53c66c2544a5f3019a594a3de06176cf1eabd0e7a078826b5c3d3e4ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb44a387ab8d1da7b8fe9f276d1bc7cddd2cadc44046c14e73fcc0281e675fad"
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
