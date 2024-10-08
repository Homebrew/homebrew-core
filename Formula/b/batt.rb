class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
    tag:      "v0.3.0",
    revision: "1b3c26035f0d60e2f0c62b901f2ffed9428fb3e7"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e46e909a49f8575cd256f9463309fa6dec034b10f91d331c7c190ebe0b65f840"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d77617cc54fecaf0fe7dd999c7f8e63e6308e285dfcc943bfa626b5dc060de6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f293f52c6e6cd08d3843e5529396b86a473002d248a87c3c9cb3191604ecf8a"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    # batt does not provide separate control for AllowNonRootAccess.
    # Normally it's changed during service file installation,
    # but brew service supersedes that, leaving a daemon refusing to
    # talk to anything non-root. Changing the defaults here.
    inreplace "conf.go", "AllowNonRootAccess:      false,",
                         "AllowNonRootAccess:      true,"
    # Limit config path to Homebrew prefix. The socket remains in /var/run
    # to deter non-root invocation of daemon
    inreplace ["conf.go", "README.md"], "/etc/batt.json", etc/"batt.json"
    # Due to local changes version tag would show v0.2.1-dirty
    system "make", "VERSION=v#{version}"
    inreplace "hack/cc.chlc.batt.plist", "/path/to/batt", bin/"batt"
    system "plutil", "-insert", "ProcessType", "-string", "Background",
                     "--", "hack/cc.chlc.batt.plist"
    bin.install "bin/batt"
    prefix.install "hack/cc.chlc.batt.plist"
  end

  def caveats
    <<~EOS
      The service must be running before most of batt's commands will work.
    EOS
  end

  service do
    name macos: "cc.chlc.batt"
    require_root true
  end

  test do
    # NB: assumes first run of batt, with no previous config.
    assert_match "config file #{etc}/batt.json does not exist, using default config",
      shell_output("#{bin}/batt daemon 2>&1", 1) # Non-root daemon exits with 1
    assert_match "failed to connect to unix socket.",
      shell_output("#{bin}/batt status 2>&1", 1) # Cannot connect to daemon
  end
end
