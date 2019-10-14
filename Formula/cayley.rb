class Cayley < Formula
  desc "Graph database inspired by Freebase and Knowledge Graph"
  homepage "https://github.com/cayleygraph/cayley"
  url "https://github.com/cayleygraph/cayley.git",
    :tag      => "v0.7.6",
    :revision => "9c843edfeaa4c7ca57c958b542a40de9c5856002"

  bottle do
    cellar :any_skip_relocation
    sha256 "377e5180df5cf802155e5d2af615f226706c0f02774b50a53b2b5d44480a151d" => :mojave
    sha256 "ce7a9c57fbf969e0cf60bc9cdf8f6e1d57e254dc506a9e509cc4d7052bbb53df" => :high_sierra
    sha256 "a745c0d7c87f43e62232be852ec8df3b8ee5e18cb6595725b5588843521164a4" => :sierra
  end

  depends_on "bazaar" => :build
  depends_on "go" => :build
  depends_on "mercurial" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/cayleygraph/cayley"
    dir.install buildpath.children

    cd dir do
      commit = Utils.popen_read("git rev-parse --short HEAD").chomp

      ldflags = %W[
        -s -w
        -X github.com/cayleygraph/cayley/version.Version=#{version}
        -X github.com/cayleygraph/cayley/version.GitHash=#{commit}
      ]

      system "go", "build", "-o", bin/"cayley", "-ldflags", ldflags.join(" "), ".../cmd/cayley"

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
