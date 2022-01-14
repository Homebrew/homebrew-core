class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.16.3",
      revision: "d420ccdaf201e32a524632b5da729522e50257ae"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2534f50ea1bc538cb79f00b42925f5ed2c1cb1c21b5411e27faefc8f6745c581"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a51879b5396bf5125c7016f36b75a06b068decc0015a07503701f280a05daec"
    sha256 cellar: :any_skip_relocation, monterey:       "fad710f0e4fccbf6ba6b13ef9ef0c1a74dacba418b353f8f2e2ac8b4884615aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "2288b22cf083452ae9af295a42b426eab7f0f37b6153b7eae851c4fda0f7e8d0"
    sha256 cellar: :any_skip_relocation, catalina:       "ebac2a274b86d8fa967faf520be8de727df24107972a936c863c29bf1ce58eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee726ed853d7b9ab262830a5d1054761e0f879eaffe9cf2ab65a552628488adc"
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
