class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/cayleygraph/cayley"
  url "https://github.com/cayleygraph/cayley/archive/v0.6.1.tar.gz"
  sha256 "33cfa8ef35813cf833ae79ba8ac2fab7f4c63afaf6103a54d969265e283d3399"
  head "https://github.com/google/cayley.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "742760d4a2fb4275a0d719df7a700e7ad4b826165a29dfb201ff09a8bfeba0fb" => :sierra
    sha256 "4fd6749b962972990f870fc88556c48a21eb27dcc176149c0c8e0f2cf796c61e" => :el_capitan
    sha256 "0094bc69ee5b69af082b1c73269df76956535b45fcd4984cc1bf0c90c69a3420" => :yosemite
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
