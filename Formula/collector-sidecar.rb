class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.4.tar.gz"
  sha256 "3d73f8054a52411ff6d71634bc93b23a55372477069fcfad699876f82ae22ce8"

  bottle do
    rebuild 1
    sha256 "91b81c42bebaf3f028bb06cca5e16d47d4cda446e98ec951a118ba73c89d19bd" => :high_sierra
    sha256 "5f3be3b9e129b33caf227a4e07f9b425f5d14689aff9b176560215300406083b" => :sierra
    sha256 "5c9508066b8e856e6e6a2ebb27fe5a59d485b254f61ab7878b365a7a41382bfb" => :el_capitan
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on :hg => :build
  depends_on "filebeat" => :run

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/Graylog2/collector-sidecar").install buildpath.children

    cd "src/github.com/Graylog2/collector-sidecar" do
      inreplace "main.go", "/etc", etc

      inreplace "collector_sidecar.yml" do |s|
        s.gsub! "/usr", HOMEBREW_PREFIX
        s.gsub! "/etc", etc
        s.gsub! "/var", var
      end

      system "glide", "install"
      system "make", "build"
      (etc/"graylog/collector-sidecar").install "collector_sidecar.yml"
      bin.install "graylog-collector-sidecar"
      prefix.install_metafiles
    end
  end

  plist_options :startup => true, :manual => "graylog-collector-sidecar"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/graylog-collector-sidecar</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graylog-collector-sidecar -version")
  end
end
