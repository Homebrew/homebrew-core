class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/cayleygraph/cayley"
  url "https://github.com/cayleygraph/cayley/archive/v0.6.0.tar.gz"
  sha256 "b55d6b02567dd0a1c51001cb25d5bde602358f621cdf78ba40bdf8a8c51422b0"
  head "https://github.com/google/cayley.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "06e628c51dffbcebc9cc881e1179c9174d445940877bba122759d2c8c67e6dbb" => :sierra
    sha256 "452f7b30fe5159cf9ef3775b8f2ecaf930b21b84c635ecd54fc003aad8ae183f" => :el_capitan
    sha256 "e3895acb97793b73d523db3060a6aa12d92460e37f2c8dbc40262bc60ab63b76" => :yosemite
  end

  option "without-samples", "Don't install sample data"

  depends_on "bazaar" => :build
  depends_on :hg => :build
  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    (buildpath/"src/github.com/cayleygraph/cayley").install buildpath.children
    cd "src/github.com/cayleygraph/cayley" do
      system "glide", "install"
      system "go", "build", "-o", bin/"cayley", "-ldflags",
             "-X main.Version=#{version}", ".../cmd/cayley"

      inreplace "cayley.cfg.example", "/tmp/cayley_test", var/"cayley"
      etc.install "cayley.cfg.example" => "cayley.conf"

      (pkgshare/"assets").install "docs", "static", "templates"

      if build.with? "samples"
        system "gzip", "-d", "data/30kmoviedata.nq.gz"
        (pkgshare/"samples").install "data/testdata.nq", "data/30kmoviedata.nq"
      end
    end
  end

  def post_install
    unless File.exist? var/"cayley"
      (var/"cayley").mkpath

      # Initialize the database
      system bin/"cayley", "init", "--config=#{etc}/cayley.conf"
    end
  end

  plist_options :manual => "cayley http --assets=#{HOMEBREW_PREFIX}/share/cayley/assets --config=#{HOMEBREW_PREFIX}/etc/cayley.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/cayley</string>
          <string>http</string>
          <string>--assets=#{opt_pkgshare}/assets</string>
          <string>--config=#{etc}/cayley.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/cayley</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/cayley.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/cayley.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cayley version")
  end
end
