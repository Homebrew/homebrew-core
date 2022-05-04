class Metricbeat < Formula
  desc "Collect metrics from your systems and services"
  homepage "https://www.elastic.co/beats/metricbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.0",
      revision: "045da3a1bb89944373c33332c18ca99ef6192df2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "800521c3889860e49aadf2c28dd9b70adb7029da1b30d0987f13c8b902e7d366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75caf9a9676dee3940e4306d34ae0904794f107fad3f76d97298b73dd588a80d"
    sha256 cellar: :any_skip_relocation, monterey:       "67a5bfe7dd11f05df6b51fa9c3fe44e5d7fb1ddf0d8e250bb8101142ff13ff2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "48a8240c71608d0f5aa2eaa3d1166a1a761c5b694db682c41427ab154e131034"
    sha256 cellar: :any_skip_relocation, catalina:       "0f9f2473cbc4375bab3a402f11e0097e0c159c2f4cbd54a8cd44484d02c05f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6cd5d79f4abd0cf15b27de6f4dfb4192d6b2226dce90185c14ad22c31c44eb8"
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
