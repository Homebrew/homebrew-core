class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.9.3",
      revision: "7aab6a9659749802201db8020c4f04b74cec2169"
  license "Apache-2.0"
  revision 1
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7772b20c57f9a30ecba10935c47319e8e4331e5e70c2febe35aa3e7da392ea01" => :catalina
    sha256 "139bdb37c31c749f035b8d41b562ec9d9573564b2761476d5b1f3adbae4341c8" => :mojave
    sha256 "543d339fd246c53539a03de207461e5d20b84ce1fe6859561bb32535fe194ba2" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "python@3.9" => :build
  depends_on "freetype"
  depends_on "jpeg"

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/28/a8/96e411bfe45092f8aeebc5c154b2f0892bd9ea462d6934b534c1ce7b7402/virtualenv-20.0.35.tar.gz"
    sha256 "2a72c80fa2ad8f4e2985c06e6fc12c3d60d060e410572f553c90619b0f6efaf3"
  end

  def install
    # Fix compatibility with recent setuptools, remove in 7.10
    # https://github.com/elastic/beats/pull/20105
    inreplace "libbeat/tests/system/requirements.txt", "MarkupSafe==1.0", "MarkupSafe==1.1.1"

    # remove non open source files
    rm_rf "x-pack"

    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    # Help Pillow find zlib
    ENV.append_to_cflags "-I#{MacOS.sdk_path}/usr/include"

    resource("virtualenv").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin" # for virtualenv
    ENV.prepend_path "PATH", buildpath/"bin" # for mage (build tool)

    cd "src/github.com/elastic/beats/auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "devtools.GenerateModuleIncludeListGo, Docs)",
                               "devtools.GenerateModuleIncludeListGo)"

      system "make", "mage"
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--use-pep517 --no-binary :all:", "python-env"
      system "mage", "-v", "build"
      system "mage", "-v", "update"

      (etc/"auditbeat").install Dir["auditbeat.*", "fields.yml"]
      (libexec/"bin").install "auditbeat"
      prefix.install "build/kibana"
    end

    prefix.install_metafiles buildpath/"src/github.com/elastic/beats"

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

  plist_options manual: "auditbeat"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>Program</key>
          <string>#{opt_bin}/auditbeat</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
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
    s = IO.readlines(testpath/"auditbeat/auditbeat").last(1)[0]
    assert_match /"action":\["(initial_scan|created)"\]/, s
    realdirpath = File.realdirpath(testpath)
    assert_match "\"path\":\"#{realdirpath}/files/touch\"", s
  end
end
