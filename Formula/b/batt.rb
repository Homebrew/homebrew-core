class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
      tag:      "v0.6.0",
      revision: "1310e0b06fe91ac206ef298fd129bde611f3cd5f"
  license "GPL-2.0-only"
  head "https://github.com/charlie0129/batt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "964942b4c4a719104a7b0049c787ae3a293e81b7ff133bd50fe3767c5aa80db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "423d7e5157cb979bd34bef1c92c29b90f75a22f89f598296ab8e188a2d2be4b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43951742e51d16008d61d164513549951e72d696787bda3227644ff8a8d03d46"
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
