class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.2.3",
      revision: "7826dc5e91c6e6d2487e05d3a8298f49041cd5c2"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21b549fc80c79409793afe68d37eea855076c524ae15e5ceb26d200a51a99c3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5fd52c9931b56fe10f21d93b60c894adc5f0d62a487b7718a78107a17b80cc43"
    sha256 cellar: :any_skip_relocation, monterey:       "118de845d8888e6ebcdab85a8d913d58e25310beea70eb48260471be6d2df633"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe61dd55fb286f9ccb2d1259d930cbc10091830c1a452e93c48e2b61a95f8558"
    sha256 cellar: :any_skip_relocation, catalina:       "b3a7c7ac26e2fe241f19607851c80d4274202ad7bb379205e062754a2617c65d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa2c2f87c42755632ed48942404ca6bc66a5e8bb45befaed03ecf2f968b732a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc/"auditbeat").install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    (bin/"auditbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/auditbeat \
        --path.config #{etc}/auditbeat \
        --path.data #{var}/lib/auditbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/auditbeat \
        "$@"
    EOS
  end

  def post_install
    (var/"lib/auditbeat").mkpath
    (var/"log/auditbeat").mkpath
  end

  service do
    run opt_bin/"auditbeat"
  end

  test do
    (testpath/"files").mkpath
    (testpath/"config/auditbeat.yml").write <<~EOS
      auditbeat.modules:
      - module: file_integrity
        paths:
          - #{testpath}/files
      output.file:
        path: "#{testpath}/auditbeat"
        filename: auditbeat
    EOS
    fork do
      exec "#{bin}/auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5
    touch testpath/"files/touch"

    sleep 30

    assert_predicate testpath/"data/beat.db", :exist?

    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"
  end
end
