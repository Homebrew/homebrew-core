class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.15.1",
      revision: "5ae799cb1c3c490c9a27b14cb463dc23696bc7d3"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "292be27a0b3a32ba5740106f4b15c43da8109b63e1e5be37bd72702189ac5d7b"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad03e564d3872852a6ccfbd8aef9343b92817967373dfb6a23e6454b7f6d8049"
    sha256 cellar: :any_skip_relocation, catalina:      "d719093680cb9bba6a1553bee95c6a8cb8610eb0fe180961c49af4f0067a14ce"
    sha256 cellar: :any_skip_relocation, mojave:        "3c6c1d5cf21faeb117f7ffd63e1abcb2f9dca224cf3f6643b2f22dec78b7bbc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95c68e340d14f84a7fff6e48b3243a025de730c43fc5ad8867ef74fd97d65182"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.9" => :build

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
