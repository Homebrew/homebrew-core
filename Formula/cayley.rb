class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/cayleygraph/cayley"
  url "https://github.com/cayleygraph/cayley/archive/v0.7.4.tar.gz"
  sha256 "37e2bb3014060f16a7b727a1157aa5420cf4fbc8746d3465c305f3b7ae147f66"
  head "https://github.com/google/cayley.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "13bf69c405651363c7a1c0fd281ca377eab0cde20c3114e00e05a407b3fffcd2" => :high_sierra
    sha256 "fdde7a5914e9cdeac1e47d63ccf3c2f40c4eeb64d97ec4c3b01dfd377e73d5ad" => :sierra
    sha256 "61c99517f32bc2fa4ab1f8190efc9874d0984e764092609da332df797bec2aca" => :el_capitan
  end

  option "without-samples", "Don't install sample data"

  depends_on "bazaar" => :build
  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "mercurial" => :build

  def install
    ENV["GOPATH"] = buildpath

    # remove for > 0.7.3
    inreplace "version/version.go", "0.7.3", "0.7.4" if build.stable?

    (buildpath/"src/github.com/cayleygraph/cayley").install buildpath.children
    cd "src/github.com/cayleygraph/cayley" do
      system "dep", "ensure"
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
