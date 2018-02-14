class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/0.1.4.tar.gz"
  sha256 "3d73f8054a52411ff6d71634bc93b23a55372477069fcfad699876f82ae22ce8"

  bottle do
    rebuild 2
    sha256 "c31cd3d9caa0d658aae224ade213d64eaa0be2e040d1b7180e78b10c1c8725a3" => :high_sierra
    sha256 "cac1fff6f16a21edca6f7b671840e9df9d076b31b37806b3f50c01b486e8ebad" => :sierra
    sha256 "d21746e91d501bbb6544a239ac8bb846727f940e3ca152f6c79262c3aa0eec1e" => :el_capitan
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "mercurial" => :build
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

  plist_options :manual => "graylog-collector-sidecar"

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
