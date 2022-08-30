class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.4.1",
      revision: "fe210d46ebc339459e363ac313b07d4a9ba78fc7"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f365e10df9e5fe0881d130bdaf53b5140c618717318cffe40afdf4a7c858db3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac1b0f668383244c24004bbd35a0640d1ad4874b4be3dfa1f67b23a814d5f23e"
    sha256 cellar: :any_skip_relocation, monterey:       "a1de7b6440c5273ee6eb917dc859db547e7e5901a7c78f6ffd8dfdb55ef0eb9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "af5442b2aea6628fb34664461803e3c9454c623096904fec803d4c981a743096"
    sha256 cellar: :any_skip_relocation, catalina:       "e3dca4960ace2c24bcfb510ff15931b1b2145f8f66ab5e856f4fb076ed58b298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9eef09c65e9ef32f4e13b4d0d111284ce60962b6cecdaf6111c41dddfe496f6"
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
