class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.2",
      revision: "3c518f4d17a15dc85bdd68a5a03d5af51d9edd8e"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6f5aae9d3aecd26f1d79caf6d6a30fada04cb78e5d2fdd184f84ac449d13817"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9600d56009a3d459b191e4e68f1f6712c1c52dcacfcb0018688d7d4fa4f1a693"
    sha256 cellar: :any_skip_relocation, monterey:       "a708b187c574501615e3fe1a51edb188ed2bab2a9954b8408172086752ad798d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2eeb0ea4b51de8b787fb13037fb97679852cae9094bb3940ef9d67e97a8394bc"
    sha256 cellar: :any_skip_relocation, catalina:       "b9c533d62eb06686a947c83a5c18a57957472b050b5531d6045c388188b8320f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b58f6f0ec815ece42e0275c1331b5c2e98f0b55f1fe3e37e2b9b5a888013b54"
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
    s = File.readlines(testpath/"auditbeat/auditbeat").last(1)[0]
    assert_match(/"action":\["(initial_scan|created)"\]/, s)
    realdirpath = File.realdirpath(testpath)
    assert_match "\"path\":\"#{realdirpath}/files/touch\"", s
  end
end
