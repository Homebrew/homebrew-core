class Cockroach < Formula
  desc "Distributed SQL database"
  homepage "https://www.cockroachlabs.com"
  url "https://binaries.cockroachdb.com/cockroach-v1.0.5.src.tgz"
  version "1.0.5"
  sha256 "8a23d992c76c4f19fbb00622c56854f90491db46090201e2d0bcfb8bd637544a"
  head "https://github.com/cockroachdb/cockroach.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3740e0a76c14e4f3e225d65208d501b13cbd050c30e600f30c2ad240e58a7b67" => :sierra
    sha256 "c93afad4c3b81c736db14bf72b81e66d70b01211ec3fed925185a22dd7e1a41e" => :el_capitan
    sha256 "e9d80efb3a6c149ff8ef514a4d20fff62683d8c2c963d02f5f6c300052e426b2" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "xz" => :build

  def install
    # unpin the Go version
    go_version = Formula["go"].installed_version.to_s.split(".")[0, 2].join(".")
    inreplace "src/github.com/cockroachdb/cockroach/.go-version",
              /^GOVERS = go.*/, "GOVERS = go#{go_version.gsub(".", "\\.")}.*"

    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    For local development only, this formula ships a launchd configuration to
    start a single-node cluster that stores its data under:
      #{var}/cockroach/
    Instead of the default port of 8080, the node serves its admin UI at:
      #{Formatter.url("http://localhost:26256")}

    Do NOT use this cluster to store data you care about; it runs in insecure
    mode and may expose data publicly in e.g. a DNS rebinding attack. To run
    CockroachDB securely, please see:
      #{Formatter.url("https://www.cockroachlabs.com/docs/secure-a-cluster.html")}
    EOS
  end

  plist_options :manual => "cockroach start --insecure"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/cockroach</string>
        <string>start</string>
        <string>--store=#{var}/cockroach/</string>
        <string>--http-port=26256</string>
        <string>--insecure</string>
        <string>--host=localhost</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    begin
      # Redirect stdout and stderr to a file, or else  `brew test --verbose`
      # will hang forever as it waits for stdout and stderr to close.
      system "#{bin}/cockroach start --insecure --background &> start.out"
      pipe_output("#{bin}/cockroach sql --insecure", <<-EOS.undent)
        CREATE DATABASE bank;
        CREATE TABLE bank.accounts (id INT PRIMARY KEY, balance DECIMAL);
        INSERT INTO bank.accounts VALUES (1, 1000.50);
      EOS
      output = pipe_output("#{bin}/cockroach sql --insecure --format=csv",
        "SELECT * FROM bank.accounts;")
      assert_equal <<-EOS.undent, output
        1 row
        id,balance
        1,1000.50
      EOS
    ensure
      system "#{bin}/cockroach", "quit", "--insecure"
    end
  end
end
