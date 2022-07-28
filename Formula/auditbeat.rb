class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.3",
      revision: "1755b5dd3127bf755ee39deb25a802438bdac620"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bcf3343358066d9cc1a4b9040e58e29a7fe27e4b98b86b992a7f17309ab27a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89b860bac85dc7143a4f154a08a6b1e73cb4c9652a9fecaad5e08a5ff3aa2402"
    sha256 cellar: :any_skip_relocation, monterey:       "b24f447e4e3dfc6608ff3f3ed1c56e5247fdf7b1c036d04960ee169924dea922"
    sha256 cellar: :any_skip_relocation, big_sur:        "5be18ffc244fe52cc1fe7bef49dc2cc7707a3ec48b24d0314565d277f4a51a6b"
    sha256 cellar: :any_skip_relocation, catalina:       "13a498aecff03a7f15c7cd90d8e0a583c4e27a78556a439c8153223ff06e86ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c8a1ef641dc1ec1ff62cabf87c1e7c56b2dae84ecaaabab53da4d84e1b94df6"
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
