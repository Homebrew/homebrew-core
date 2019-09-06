class CollectorSidecar < Formula
  desc "Manage log collectors through Graylog"
  homepage "https://github.com/Graylog2/collector-sidecar"
  url "https://github.com/Graylog2/collector-sidecar/archive/1.0.2.tar.gz"
  sha256 "ee7ddb725d3475656df0bb08476e64c7f919acfc011a338b4532249363778130"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fd3f90118fd74def3149ad3d5274be35cc46391b6a5b15d4e83166df8339ed9" => :mojave
    sha256 "fa3d4c45fb010868fbf00b9053deb83d96bd1c5983b6cd22878a81f2819fba50" => :high_sierra
    sha256 "1835ef088e6fa9ff35e278ec025f2e7b365e1daa5b8b53d9db46e08166e2ccdf" => :sierra
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
