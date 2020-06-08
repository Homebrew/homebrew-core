class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/cayleygraph/cayley"
  url "https://github.com/cayleygraph/cayley.git",
    :tag      => "v0.7.7",
    :revision => "dcf764fef381f19ee49fad186b4e00024709f148"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "de8d93ba5a00e4ebe718da6f3886488c3e0dfcd532725d7382c0901f9b17d019" => :catalina
    sha256 "d7981f2af823da8ad9f0553fa11349a25b241500a8cb29e1758040f0c01c41ef" => :mojave
    sha256 "4fc00116b7b447a52111cc021c65f70770b4c4543365d49b7acde11ee13c5a70" => :high_sierra
  end

  depends_on "bazaar" => :build
  depends_on "go" => :build
  depends_on "mercurial" => :build

  def install
    dir = buildpath/"src/github.com/cayleygraph/cayley"
    dir.install buildpath.children

    cd dir do
      # Run packr to generate .go files that pack the static files into bytes that can be bundled into the Go binary.
      system "go", "run", "github.com/gobuffalo/packr/v2/packr2"

      commit = Utils.safe_popen_read("git rev-parse --short HEAD").chomp

      ldflags = %W[
        -s -w
        -X github.com/cayleygraph/cayley/version.Version=#{version}
        -X github.com/cayleygraph/cayley/version.GitHash=#{commit}
      ]

      # Build the binary
      system "go", "build", "-o", bin/"cayley", "-ldflags", ldflags.join(" "), "./cmd/cayley"

      inreplace "cayley_example.yml", "./cayley.db", var/"cayley/cayley.db"
      etc.install "cayley_example.yml" => "cayley.yml"

      # Install samples
      system "gzip", "-d", "data/30kmoviedata.nq.gz"
      (pkgshare/"samples").install "data/testdata.nq", "data/30kmoviedata.nq"
    end
  end

  def post_install
    unless File.exist? var/"cayley"
      (var/"cayley").mkpath

      # Initialize the database
      system bin/"cayley", "init", "--config=#{etc}/cayley.yml"
    end
  end

  plist_options :manual => "cayley http --config=#{HOMEBREW_PREFIX}/etc/cayley.conf"

  def plist
    <<~EOS
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

    http_port = free_port
    fork do
      exec "#{bin}/cayley", "http", "--host=127.0.0.1:#{http_port}"
    end
    sleep 3
    response = shell_output("curl -s -i 127.0.0.1:#{http_port}")
    assert_match "HTTP\/1.1 200 OK", response
  end
end
