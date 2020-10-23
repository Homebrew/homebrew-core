class Packetbeat < Formula
  desc "Lightweight Shipper for Network Data"
  homepage "https://www.elastic.co/products/beats/packetbeat"
  url "https://github.com/elastic/beats.git",
    tag:      "v7.9.3",
    revision: "7aab6a9659749802201db8020c4f04b74cec2169"
  license "Apache-2.0"
  revision 1
  head "https://github.com/elastic/beats.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cc7ffaa87e8e059d2fc56c202cc5844f2bcd05358c1bc16588d70c1c9dec12d" => :catalina
    sha256 "3dc4ac4e4e4e06cccd0f2b4c9264d264b4dca4ebf1377954d8fd294b63938676" => :mojave
    sha256 "e9240b9b19b296a1bcb7f641e76a5661ac39e2ecd64b5d019f61c0940c9fd9d6" => :high_sierra
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

    cd "src/github.com/elastic/beats/packetbeat" do
      system "make", "mage"
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--use-pep517 --no-binary :all:", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      inreplace "packetbeat.yml", "packetbeat.interfaces.device: any", "packetbeat.interfaces.device: en0"

      (etc/"packetbeat").install Dir["packetbeat.*", "fields.yml"]
      (libexec/"bin").install "packetbeat"
      prefix.install "_meta/kibana"
    end

    prefix.install_metafiles buildpath/"src/github.com/elastic/beats"

    (bin/"packetbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/packetbeat \
        --path.config #{etc}/packetbeat \
        --path.data #{var}/lib/packetbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/packetbeat \
        "$@"
    EOS
  end

  plist_options manual: "packetbeat"

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
          <string>#{opt_bin}/packetbeat</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match "0: en0", shell_output("#{bin}/packetbeat devices")
    assert_match version.to_s, shell_output("#{bin}/packetbeat version")
  end
end
