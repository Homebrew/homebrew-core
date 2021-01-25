class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/cayleygraph/cayley"
  url "https://github.com/cayleygraph/cayley.git",
      tag:      "v0.7.7",
      revision: "dcf764fef381f19ee49fad186b4e00024709f148"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "9217369e4d1d1863fd23a2694a3962510a52380b385c199008191c302629f0ac" => :big_sur
    sha256 "ead8a905c38526bdc7812eb1d500cf9dcb90c8c9dbb73126e1b3da463a4520c9" => :arm64_big_sur
    sha256 "7fe446d8eaa6ed43ae226027feec3878e437708d4a59c5aab761ab249bc9ba56" => :catalina
    sha256 "7084bd5b3b7dc66c9c50266f2831951f995901f2a326905c760646ebe66a3b96" => :mojave
    sha256 "0dc598decbc9c70660d22fc670f71581e7fec09e5c9d9bc13ccee4c88c758338" => :high_sierra
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

      ldflags = %W[
        -s -w
        -X github.com/cayleygraph/cayley/version.Version=#{version}
        -X github.com/cayleygraph/cayley/version.GitHash=#{Utils.git_short_head}
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

  plist_options manual: "cayley http --config=#{HOMEBREW_PREFIX}/etc/cayley.conf"

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
