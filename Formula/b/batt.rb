class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
      tag:      "v0.3.4",
      revision: "296bc6c50e18e0ca371bacdb7648f9212f9f6f2e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3a86321ae93e4b8ef2388bce614194fa5cd3e2c767d97254844b5a9bcfb4978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1a01cdbc3c255903ceed314ef9d0a42bc6fe3fc1558655817ca283a03f257be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d0a0c3bdfdb7af80a89b7c27f027b0a7d561c263e97a8948f67d3502e644af7"
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
