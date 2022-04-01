class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.1.2",
      revision: "6118f25235a52a7f0c4937a0a309e380c92d8119"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5cc37b2b1ca3918ffe0455521f944dc22801ed60cf83ea06683318174ffcc51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67e3b98a80eefb24a6b8f267a9d4403637b358ea87029e711237088ace5bc5b1"
    sha256 cellar: :any_skip_relocation, monterey:       "882be1d8cb5664c21d76448a31115fa3f7e18b3b94ee08bf0299dc412cc0120b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a7017491821208fecf92b015f60dd7b43f259130dc98419ef170cb3a59143b2"
    sha256 cellar: :any_skip_relocation, catalina:       "eb6eed6010095a65a3afb7a54a6e8cebf5f839756962c6e7f1c60661ddc2cb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "891da175d6598991234ff1bbd121bc4baad3cf9d7308e7c8fe3bfff921ae000c"
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
