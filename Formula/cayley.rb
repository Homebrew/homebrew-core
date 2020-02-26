class Cayley < Formula
  desc "An open-source graph database"
  homepage "https://cayley.io/"
  url "https://github.com/cayleygraph/cayley.git",
    :tag      => "v0.7.7",
    :revision => "dcf764fef381f19ee49fad186b4e00024709f148"

  bottle do
    cellar :any_skip_relocation
    sha256 "e647be34623b1a8d635df7508f09111dfd8eb6f368a6979f9c5619b016beda8c" => :mojave
    sha256 "4177fdcb60422d484f1377e5367844ebcc9be471fffc76e717d8ad90e49ee99c" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gobuffalo/tap/packr" => :build

  CONFIGURATION_FILE = "cayley.json"
  CONFIGURATION_FILE.freeze

  LOG_FILE = "cayley.log"
  LOG_FILE.freeze


  def install
    ENV["GOPATH"] = ""
    # Define directories
    dir = buildpath/"src/github.com/cayleygraph/cayley"
    dir.install buildpath.children
    cd dir do
      source_configuration_file = "configurations/persisted.json"
      version_flag = "github.com/cayleygraph/cayley/version.Version"
      git_revision_flag = "github.com/cayleygraph/cayley/version.GitHash"
      db_default_path = "data/cayley.db"
      db_path = var/"cayley"/"cayley.db"
      
      commit = Utils.popen_read("git rev-parse --short=12 HEAD").chomp

      ldflags = "-s -w -X #{version_flag}=#{version} -X #{git_revision_flag}=#{commit}"

      # Remove packr dummy files
      File.delete("internal/http/http-packr.go")
      FileUtils.remove_dir("packrd")

      # Run packr to generate .go files that pack the static files into bytes that can be bundled into the Go binary.
      system "packr2"

      # Build the binary
      system "go", "build", "-o", bin/"cayley", "-ldflags", ldflags, "./cmd/cayley"

      inreplace source_configuration_file, db_default_path, db_path
      etc.install source_configuration_file => CONFIGURATION_FILE
    end
  end

  def post_install
    base_path = var/"cayley"
    unless File.exist? base_path
      base_path.mkpath

      # Initialize the database
      system bin/"cayley", "init", "--config=#{etc}/#{CONFIGURATION_FILE}"
    end
  end

  plist_options :manual => "cayley http --config=#{HOMEBREW_PREFIX}/etc/#{CONFIGURATION_FILE}"

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
          <string>--config=#{etc}/#{CONFIGURATION_FILE}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/cayley</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{LOG_FILE}</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/#{LOG_FILE}</string>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cayley version")
    server = Thread.new { system "#{bin}/cayley", "http" }
    response = Net::HTTP.get('localhost:64210', '/')
    refute_empty response, "Response must not be empty"
    server.terminate
  end
end
