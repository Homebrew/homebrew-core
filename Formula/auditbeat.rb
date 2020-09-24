class Auditbeat < Formula
  desc "Lightweight Shipper for Audit Data"
  homepage "https://www.elastic.co/products/beats/auditbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v7.9.2",
      revision: "2ab907f5ccecf9fd82fe37105082e89fd871f684"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "efca3746f1863eb2bd303cfe2d8199b47137dfa4f4421939b67d1f23499d6dd1" => :catalina
    sha256 "810c2f0dbe5f7da523e830fffa06d1ce633db9f3a225d000580b3554cd28949a" => :mojave
    sha256 "d31b702da405364e3c12c7c593a17ab11813523b4c6bc3c22827a933c3461d53" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "python@3.8" => :build

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d4/0c/9840c08189e030873387a73b90ada981885010dd9aea134d6de30cd24cb8/virtualenv-15.1.0.tar.gz"
    sha256 "02f8102c2436bb03b3ee6dede1919d1dac8a427541652e5ec95171ec8adbc93a"
  end

  # Update MarkupSafe to 1.1.1, remove with next release
  # https://github.com/elastic/beats/pull/20105
  patch do
    url "https://github.com/elastic/beats/commit/5a6ca609259956ff5dd8e4ec80b73e6c96ff54b2.patch?full_index=1"
    sha256 "b362f8921611297a0879110efcb88a04cf660d120ad81cd078356d502ba4c2ce"
  end

  def install
    # remove non open source files
    rm_rf "x-pack"

    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elastic/beats").install buildpath.children

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{xy}/site-packages"

    resource("virtualenv").stage do
      system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(buildpath/"vendor")
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
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
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
