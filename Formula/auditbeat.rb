class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      :tag      => "v6.8.1",
      :revision => "6e16f47450373f04d6a60db1d23c5b13b37f7431"
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a48d40026cd8e289f54e7aca084c3a157357b138d871759e05d2596847af041" => :mojave
    sha256 "5554228254742a6ce6b1da87374160fd2e09aa73accda060be54378c89794544" => :high_sierra
    sha256 "cf82c02743ef6693319cfc2988bcc218fd71bac399acc1a30cf3b9d6ae0f72cf" => :sierra
  end

  depends_on "go" => :build
  depends_on "python@2" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/8b/f4/360aa656ddb0f4168aeaa1057d8784b95d1ce12f34332c1cf52420b6db4e/virtualenv-16.3.0.tar.gz"
    sha256 "729f0bcab430e4ef137646805b5b1d8efbb43fe53d4a0f33328624a84a5121f7"
  end

  # Patch required to build against go 1.11 (Can be removed with v7.0.0)
  # partially backport of https://github.com/elastic/beats/commit/8d8eaf34a6cb5f3b4565bf40ca0dc9681efea93c
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a0f8cdc0/auditbeat/go1.11.diff"
    sha256 "8a00cb0265b6e2de3bc76f14f2ee4f1a5355dad490f3db9288d968b3e95ae0eb"
  end

  def install
    # remove non open source files
    rm_rf "x-pack"

    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python2.7/site-packages"

    resource("virtualenv").stage do
      system "python", *Language::Python.setup_install_args(buildpath/"vendor")
    end

    ENV.prepend_path "PATH", buildpath/"vendor/bin" # for virtualenv
    ENV.prepend_path "PATH", buildpath/"bin" # for mage (build tool)

    cd "src/github.com/elastic/beats/auditbeat" do
      # don't build docs because it would fail creating the combined OSS/x-pack
      # docs and we aren't installing them anyway
      inreplace "magefile.go", "mage.GenerateModuleIncludeListGo, Docs)",
                               "mage.GenerateModuleIncludeListGo)"

      system "make", "mage"
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_COMMANDS=--no-binary :all", "python-env"
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

  plist_options :manual => "auditbeat"

  def plist; <<~EOS
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
    pid = fork do
      exec "#{bin}/auditbeat", "-path.config", testpath/"config", "-path.data", testpath/"data"
    end
    sleep 5

    begin
      touch testpath/"files/touch"
      sleep 30
      s = IO.readlines(testpath/"auditbeat/auditbeat").last(1)[0]
      assert_match "\"action\":\[\"created\"\]", s
      realdirpath = File.realdirpath(testpath)
      assert_match "\"path\":\"#{realdirpath}/files/touch\"", s
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
