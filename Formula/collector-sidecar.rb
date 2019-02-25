class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/1.0.0.tar.gz"
  sha256 "9aad3bdedee846ad2019c7bd71f9b8c019795c06127871dd878232a7a7c7b9d3"

  bottle do
    sha256 "359e7f94011d08bf83936c5419fb2392341815f125d90a21638b78776d98d631" => :mojave
    sha256 "1d776ff4aab044186ff5e4e7c92de549340f6a2a1cb68e1bd72055c482b3210c" => :high_sierra
    sha256 "4cdb998258223bdcacaa6b36d3c486444dd95aa72a91a818ddb0a92ae0a208f1" => :sierra
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
