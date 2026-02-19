class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
      tag:      "v0.7.1",
      revision: "dee6bd30c74569c5adca682474206538666a404c"
  license "GPL-2.0-only"
  head "https://github.com/charlie0129/batt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "825913e987008f0d9cb744f931428d172868001e460806f59050f0648cd8353c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b200e372c9fe057c3ade08a6c5ff8bc7f207f40b3b0fe1520b42f41347c8649f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f6e9309ed938a9399b702db522cd52eb0b24c376b575d9b6bdb3451189edb3"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    # Point to the correct path for the binary
    inreplace "hack/cc.chlc.batt.plist", "/path/to/batt", opt_bin/"batt"
    # Limit config path to Homebrew prefix.
    system "plutil", "-insert", "ProgramArguments",
           "-string", "--config=#{etc}/batt.json", "-append",
           "--", "hack/cc.chlc.batt.plist"
    # Allow non-root access to the battery controller.
    system "plutil", "-insert", "ProgramArguments",
           "-string", "--always-allow-non-root-access", "-append",
           "--", "hack/cc.chlc.batt.plist"
    # Due to local changes version tag would show vx.x.x-dirty, override VERSION.
    # GOTAGS is set to disable built-in install/uninstall commands when building for Homebrew.
    system "make", "GOTAGS=brew", "VERSION=v#{version}"
    bin.install "bin/batt"
    prefix.install "hack/cc.chlc.batt.plist"

    generate_completions_from_executable(bin/"batt", shell_parameter_format: :cobra)
  end

  def caveats
    <<~EOS
      The batt service must be running before most of batt's commands will work.
    EOS
  end

  service do
    name macos: "cc.chlc.batt"
    require_root true
  end

  test do
    # batt is only meaningful on Mac laptops. There is not much we can test
    # in a VM.
    assert_match "operation not permitted", # Non-root daemon cannot listen in /var/run
      shell_output("#{bin}/batt daemon --config=#{etc}/batt.json 2>&1", 1) # Non-root daemon exits with 1
    assert_match "batt daemon is not running",
      shell_output("#{bin}/batt status 2>&1", 1) # Cannot connect to daemon
  end
end
