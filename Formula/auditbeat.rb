class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.17.0",
      revision: "93708bd74e909e57ed5d9bea3cf2065f4cc43af3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "218886009bc8e10cac897e5501aeeb979a4ec78d31de95ba5e3577ac77ddc267"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99adac1f8aa07568bcfdd375a36b6f3da6fa31cf6cfc75211a5a04cd28e9da45"
    sha256 cellar: :any_skip_relocation, monterey:       "e026c27e62144e9d83ee9fdb2231433a23442421e42a6528edd323ce1780d3f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "978d847f53f8ccce51368699c5c5950e092e3320da20db54e662665c01a385d6"
    sha256 cellar: :any_skip_relocation, catalina:       "3738910402d76b41ffd7dd6f9f06a5333a1469031b30bd8d0f8516fd3e937873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc503dd11785e09002aff468bb6537c54e04d23d0faa57f01851a77f817dd08a"
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
