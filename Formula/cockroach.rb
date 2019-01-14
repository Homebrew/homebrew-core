class Cockroach < Formula
  desc "Distributed SQL database"
  homepage "https://www.cockroachlabs.com"
  url "https://binaries.cockroachdb.com/cockroach-v2.1.3.src.tgz"
  version "2.1.3"
  sha256 "16d851a131e17002af04ad56e4adfec8182bf5ec55496ef2fcefe0461e16933e"
  head "https://github.com/cockroachdb/cockroach.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7c3a0f504755d798464727c872ab82dcf177ae90c786c24c14c7a177b535e51" => :mojave
    sha256 "92c64365d3fb1495bb10b78dfe8f9b4fca5d9b62e56eed5c4ead582ac53c6120" => :high_sierra
    sha256 "f9944ae962f012b3cc5225807e40cfd54be5f515907c18c6f48767ccb466c819" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "xz" => :build

  def install
    # The GNU Make that ships with macOS Mojave (v3.81 at the time of writing) has a bug
    # that causes it to loop infinitely when trying to build cockroach. Use
    # the more up-to-date make that Homebrew provides.
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    # Build only the OSS components
    system "make", "buildoss"
    system "make", "install", "prefix=#{prefix}", "BUILDTYPE=release"
  end

  def caveats; <<~EOS
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

  def plist; <<~EOS
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
      pipe_output("#{bin}/cockroach sql --insecure", <<~EOS)
        CREATE DATABASE bank;
        CREATE TABLE bank.accounts (id INT PRIMARY KEY, balance DECIMAL);
        INSERT INTO bank.accounts VALUES (1, 1000.50);
      EOS
      output = pipe_output("#{bin}/cockroach sql --insecure --format=csv",
        "SELECT * FROM bank.accounts;")
      assert_equal <<~EOS, output
        id,balance
        1,1000.50
      EOS
    ensure
      system "#{bin}/cockroach", "quit", "--insecure"
    end
  end
end
