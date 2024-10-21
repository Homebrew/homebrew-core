class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
    tag:      "v0.3.2",
    revision: "ee66300b0e19bd2d6c423143babd68f23ae01b62"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baa5509e6ad1f4a7b6d57e9b336df47068fc24ab1047b7c7285533a038a18011"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256ef16bf5f26f400b0946898ef1703a09716d776e74da9e84c8492cf0b05e75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c03808c6f8c04dce15217eb663982ba623c39e5e0573088f27695d0768a1077"
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
    # NB: assumes first run of batt, with no previous config.
    assert_match "config file #{etc}/batt.json does not exist, using default config",
      shell_output("#{bin}/batt daemon --config=#{etc}/batt.json 2>&1", 1) # Non-root daemon exits with 1
    assert_match "failed to connect to unix socket.",
      shell_output("#{bin}/batt status 2>&1", 1) # Cannot connect to daemon
  end
end
