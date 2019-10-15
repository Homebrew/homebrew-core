class Cockroach < Formula
  desc "Distributed SQL database"
  homepage "https://www.cockroachlabs.com"
  url "https://binaries.cockroachdb.com/cockroach-v19.1.5.src.tgz"
  version "19.1.5"
  sha256 "1e3329a56e5a1729ed3ac4ff0a97943163325dd4825e8c7c8c1d9fd57bfddfde"
  head "https://github.com/cockroachdb/cockroach.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "28fe948b12b6d92f968c4186ff0d07c708c86fca39088d31d2671c04c02aba77" => :catalina
    sha256 "70d8f59b43661582cb1e7dc2d69c376436ddde87806edfbe431a60fdf6a7efcc" => :mojave
    sha256 "895adf66dbeb3838f3655f37f35d80db67f79ad388b6448939740ab09c31d5f5" => :high_sierra
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

    # Patch the CXX_FLAGS used to build rocksdb as a workaround for the issue fixed by
    # https://github.com/facebook/rocksdb/pull/5779. Furthermore on 10.14 (Mojave) and
    # later we also allow defaulted-function-delete as a workaround for
    # https://github.com/facebook/rocksdb/pull/5095.
    if MacOS.version < "10.14"
      patch = <<~PATCH
        253c253
        <     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
        ---
        >     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror -Wno-error=shadow")
      PATCH
    else
      patch = <<~PATCH
        253c253
        <     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
        ---
        >     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror -Wno-error=shadow -Wno-error=defaulted-function-deleted")
      PATCH
    end
    patchfile = Tempfile.new("patch")
    begin
      patchfile.write(patch)
      patchfile.close
      system "patch", "src/github.com/cockroachdb/cockroach/c-deps/rocksdb/CMakeLists.txt", patchfile.path
    ensure
      patchfile.unlink
    end

    # Ensure that go modules are not used as cockroachdb does not support them.
    ENV["GO111MODULE"] = "off"

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

    Due to a license change, the cockroach package in homebrew-core will no
    longer be updated when CockroachDB 19.2 is released. Please switch to
    https://github.com/cockroachdb/homebrew-tap instead.
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
