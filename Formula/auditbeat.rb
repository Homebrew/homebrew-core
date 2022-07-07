class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.2",
      revision: "45f722f492dcf1d13698c6cf618b339b1d4907be"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79da7e1832fbbdc14f2a6934f942151846ccf76d8b62fefe5a3fcde9477ff010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "108b58e63fc63701ad77f7ea6b1293d7a363f66fa41746a1989ae4c176a0e769"
    sha256 cellar: :any_skip_relocation, monterey:       "c6adb4310578c5ad6832eb6fb74553c7aa8ac2c079411eb204534039ba2570d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "57be6f07834378d70abd25e74f1e4629a3892c78c0c0f7e06e22cb62ef20b010"
    sha256 cellar: :any_skip_relocation, catalina:       "b3d757d1bbc8c508677bea071b81b1cfb32a4e67f5a8354f734f46f09d007858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56c4f192a27bfb41c0130df8970d4fad9401cf9b3c7fbe5e41d694063fe082a8"
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
