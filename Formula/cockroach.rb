class Cockroach < Formula
  desc "Distributed SQL database"
  homepage "https://www.cockroachlabs.com"
  url "https://binaries.cockroachdb.com/cockroach-v19.1.2.src.tgz"
  version "19.1.2"
  sha256 "fb43cbe938be7a44238cef6e545a4a8f333bc0c56007d102225720dfc501bda0"
  head "https://github.com/cockroachdb/cockroach.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d58509e154e60bac9de2e094695114a8357ff17373ffe77c8b80fc1125fb4aac" => :mojave
    sha256 "52db3b7236d44d9b859f7e998025c69caa1d9dd7aca826134697926603ff72de" => :high_sierra
    sha256 "f8da28d0cdbb6a3fdec3e82735a5f5351065ed8caa2e77e910b3aa9994a1f782" => :sierra
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
    rescue => e
      # If an error occurs, attempt to print out any messages from the
      # server.
      begin
        $stderr.puts "server messages:", File.read("start.out")
      rescue
        $stderr.puts "unable to load messages from start.out"
      end
      raise e
    ensure
      system "#{bin}/cockroach", "quit", "--insecure"
    end
  end
end
