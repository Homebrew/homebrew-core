class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.2",
      revision: "6118f25235a52a7f0c4937a0a309e380c92d8119"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e57a1311eab08113bf9952dbb533ea1ae50b8cba5176be6c6f38fcbf388e0993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d3742161f2bf227d5033de1bf4febc7f002e14fe432867b985ef84c0f51b23f"
    sha256 cellar: :any_skip_relocation, monterey:       "92e8e1116f295a84e3b068a8131228d371dc73053da39c466d0051e2d2651ae3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0967d523a9fdb217d434d13d82bd623be9a54ab4c3c2849e7def481ee5ae0be5"
    sha256 cellar: :any_skip_relocation, catalina:       "b560af0d60fbc2ef77e8ede4a6dcc1a095f625a242fc87b30ffa7d7ba8e3f0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ef104e5b84c12750effd46ce51ce3d58f5b2a70266b1864f78a201b98ec563"
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
