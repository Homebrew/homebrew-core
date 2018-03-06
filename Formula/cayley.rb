class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/cayleygraph/cayley"
  url "https://github.com/cayleygraph/cayley/archive/v0.7.2.tar.gz"
  sha256 "12be10ef129fef84392f2056a56a9f29ac8e1ecfb8facf1d5b5cff17a81e8e97"
  head "https://github.com/google/cayley.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da3ebc16ae88c74fe4d4fcf1e4721e009f93eb3f237f846585120936a251bd41" => :high_sierra
    sha256 "f66d9137ad0bed1614ef52b3bf654fd9ccb55dd4479d45f9622d88f3ec1e34b5" => :sierra
    sha256 "2404473b2973f8d47fb40a0eac16998d1e27b1036901261f47f07a7cbccdc713" => :el_capitan
  end

  option "without-samples", "Don't install sample data"

  depends_on "bazaar" => :build
  depends_on "mercurial" => :build
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

      inreplace "cayley_example.yml", "./cayley.db", var/"cayley/cayley.db"
      etc.install "cayley_example.yml" => "cayley.yml"

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
      system bin/"cayley", "init", "--config=#{etc}/cayley.yml"
    end
  end

  plist_options :manual => "cayley http --assets=#{HOMEBREW_PREFIX}/share/cayley/assets --config=#{HOMEBREW_PREFIX}/etc/cayley.conf"

  def plist; <<~EOS
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
