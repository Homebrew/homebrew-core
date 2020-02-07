class Cayley < Formula
  desc "An open-source graph database"
  homepage "https://cayley.io/"
  url "https://github.com/cayleygraph/cayley.git",
    :tag      => "v0.7.7",
    :revision => "dcf764fef381f19ee49fad186b4e00024709f148"
  version "0.7.7"
  sha256 "37ef9043cb20aeffa93d57f360fdee3e0c9d1b2fa8d404a00f3bff1b58937206"

  sha256 "37ef9043cb20aeffa93d57f360fdee3e0c9d1b2fa8d404a00f3bff1b58937206"

  bottle do
    cellar :any_skip_relocation
    sha256 "e647be34623b1a8d635df7508f09111dfd8eb6f368a6979f9c5619b016beda8c" => :mojave
    sha256 "4177fdcb60422d484f1377e5367844ebcc9be471fffc76e717d8ad90e49ee99c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # Set up environment variables
    ENV["GOPATH"] = buildpath

    # Define directories
    dir = buildpath/"src/github.com/cayleygraph/cayley"
    dir.install buildpath.children

    cd dir do
      source_configuration_file = "configurations/persisted.json"
      configuration_file = "cayley.json"
      version_flag = "github.com/cayleygraph/cayley/version.Version"
      git_revision_flag = "github.com/cayleygraph/cayley/version.GitHash"
      db_default_path = "data/cayley.db"
      log_file=var/"log"/"cayley.log"
      base_path = var/"cayley"
      db_path = base_path/"cayley.db"
      
      commit = Utils.popen_read("git rev-parse --short=12 HEAD").chomp

      ldflags = "-s -w -X #{version_flag}=#{version} -X #{git_revision_flag}=#{commit}"

      # Download dependencies
      system "go" "mod" "download"
      
      # Download UI
      system "go" "run" "cmd/download_ui/download_ui.go"

      # Run packr to generate .go files that pack the static files into bytes that can be bundled into the Go binary.
      system "packr2"

      # Build the binary
      system "go", "build", "-o", bin/"cayley", "-ldflags", ldflags, ".../cmd/cayley"

      inreplace source_configuration_file, db_default_path, db_path
      etc.install source_configuration_file => configuration_file
    end
  end

  def post_install
    unless File.exist? base_path
      (base_path).mkpath

      # Initialize the database
      system bin/"cayley", "init", "--config=#{etc}/#{configuration_file}"
    end
  end

  plist_options :manual => "cayley http --config=#{HOMEBREW_PREFIX}/etc/#{configuration_file}"

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
          <string>--config=#{etc}/#{configuration_file}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{base_path}</string>
        <key>StandardErrorPath</key>
        <string>#{log_file}</string>
        <key>StandardOutPath</key>
        <string>#{log_file}</string>
      </dict>
    </plist>
  EOS
    bin.install "cayley"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cayley version")
  end
end
