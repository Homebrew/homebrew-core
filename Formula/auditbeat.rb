class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.3.0",
      revision: "0ee1ead440422ce0eafb95031c0de20180d75a49"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ce6105d980e4fd0a06d17536920e18bacf7aab09a71566c137f297eed9adc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e39a43c600cf12fe1433342ea58146582ec06173ee2fb6a69267acb00ccf39c"
    sha256 cellar: :any_skip_relocation, monterey:       "7763d1c718a2cbdd50058bfb6ddc68aed99283a6e3c9dc61b80b8cbeedd39b93"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdba4b6c024517215af905ff2cd14b84d7eedbf94f506c0cd75fdc3d200d1ee9"
    sha256 cellar: :any_skip_relocation, catalina:       "a580e22b4299082c0e650c8ac7676bc137e0ef19a394b82f4b479a8ad2578379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d41e24d7d72de8bebfbc43b9a2537b259f8f30a7ded584d23e8ff9d68b4e0854"
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
