class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/1.0.1.tar.gz"
  sha256 "ec7b2ff3390b4dff01f094c268699edf0559ebb2b7c53e5e14859982b638319a"

  bottle do
    cellar :any_skip_relocation
    sha256 "59c1211e35aaac3ff8281b34771ba916c8c81b9b872f461de90e6bfcf1d63012" => :mojave
    sha256 "570afe4bb9e2f9703a82e22b88872a26ccb88a7f959a5a63b73031e54d0d54da" => :high_sierra
    sha256 "8431b7262c391f576ee4048988408d5beb2088466cee02797ab4ebb305bb17ea" => :sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "mercurial" => :build
  depends_on "filebeat"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    (buildpath/"src/github.com/Graylog2/collector-sidecar").install buildpath.children

    cd "src/github.com/Graylog2/collector-sidecar" do
      inreplace "main.go", "/etc", etc

      inreplace "sidecar-example.yml" do |s|
        s.gsub! "/usr", HOMEBREW_PREFIX
        s.gsub! "/etc", etc
        s.gsub! "/var", var
      end

      system "glide", "install"
      system "make", "build"
      (etc/"graylog/sidecar/sidecar.yml").install "sidecar-example.yml"
      bin.install "graylog-sidecar"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "graylog-sidecar"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_bin}/graylog-sidecar</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graylog-sidecar -version")
  end
end
