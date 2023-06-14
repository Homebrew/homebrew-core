class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.8.1",
      revision: "7ba375a8778fe6c1a61376a6c015e8cea71caf21"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf45299e53fc6caf8663b2139a8d5304a95e4ca2044b123573384ba8eb1b9739"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4e0bb81fb5533f40a0b8d8f52ad0afa1155c0617ec67f80817cdc6c8e674895"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adb371eaab000b664b6e94b5e174959e6d5397f71838fae6e5df41f1774af8dd"
    sha256 cellar: :any_skip_relocation, ventura:        "fdafa63dd4ee4eaab9a5c13e708ee00225a870dbe9715161bf9697fc1c49889a"
    sha256 cellar: :any_skip_relocation, monterey:       "ce32f0ec7f8bf5b9ebf730e7c674436836b7fd73d3cfee6bfb757515f9c4b061"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb24b275d32e693b7cd39b0fa86733136447b419d7dc4e8edb0858dba4e2b8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c7fd0c9462d3130677f1af236bf0a47d93b5c9f6c586aa80ce1cd06b7ae0e81"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build

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

    chmod 0555, bin/"auditbeat"
    generate_completions_from_executable(bin/"auditbeat", "completion", shells: [:bash, :zsh])
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
