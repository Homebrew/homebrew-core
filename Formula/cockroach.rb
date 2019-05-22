class Cockroach < Formula
  desc "Distributed SQL database"
  homepage "https://www.cockroachlabs.com"
  url "https://binaries.cockroachdb.com/cockroach-v19.1.1.src.tgz"
  version "19.1.1"
  sha256 "cc05d2f0a4310d23007985a91a2e3ac4ab17b9cd853934536228e6e4812c7fed"
  head "https://github.com/cockroachdb/cockroach.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f098dcc0ad0e1b1dcf70e6eed9a055016c9bc3b6738539ce25d010ba77d6c5c" => :mojave
    sha256 "a922a035b86966b2bcf51097791c144a8de7bc341fe4980cbfe6927d29d407ab" => :high_sierra
    sha256 "5c7371a4b225c20669e4bdd180abf1389b4dc141e79c7cb2850022783d85fe8a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "xz" => :build

  # Compiling CockroachDB v19.1 with Go 1.12 changes the behavior of setrlimit
  # in a way that causes CockroachDB to crash upon startup if kern.maxfiles is
  # too low. This patch backports the upstream fix from
  # cockroachdb/cockroach#37705, which will be included in the next release.
  # Note that the pull request patch cannot be used directly, as the paths in
  # the release tarball do not exactly match the paths in the Git repository.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/cockroach/v19.1.1-kern-maxfiles-w-go-1.12.patch"
    sha256 "7735ef5d3598214100f0bb3dbb718a499386987b99296ceb9c9f97a3945fd0ba"
  end

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
