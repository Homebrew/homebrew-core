class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
    tag:      "v0.2.1",
    revision: "90df4aaefb930ab05a6763c96866e8db0faf698e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9aea7e73d8f35fecb4538915741bc9338d0e076d07d68882137cd2f895acca57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab9b98798b385d490d20244727705067cbb98a2245f2a9edd00179f6615ca30b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe4b87bb7e401deed1cc4db56a40d36f79f1b41bfbf44628805517eb112ff11c"
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
