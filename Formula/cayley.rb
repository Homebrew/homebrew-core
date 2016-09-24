class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/google/cayley"
  url "https://github.com/google/cayley/archive/v0.5.0.tar.gz"
  sha256 "2f48445377bc73b125a7f65c01307fa301e4996e536fa83b42a2fcbaa2141e82"
  head "https://github.com/google/cayley.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "534940e21466304d1cd3f41bcd6c16b428567dc568f9ab6fb50b1141eae9d2b6" => :el_capitan
    sha256 "75b8e3c300a50bf85e9d6aa394313aeed9a5e12d39258343dcb3c6dbad2fc013" => :yosemite
    sha256 "b4e736e73826c1c1caafc5b6fca77be722bb6f0d7b30c8d8e77646bf6e621269" => :mavericks
  end

  option "without-samples", "Don't install sample data"

  depends_on "bazaar" => :build
  depends_on :hg => :build
  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/google/cayley").install buildpath.children
    cd "src/github.com/google/cayley" do
      system "godep", "restore"
      system "go", "build", "-ldflags=-X main.Version=#{version}", "cmd/cayley/cayley.go"
      bin.install "cayley"

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
