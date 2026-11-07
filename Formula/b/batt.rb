class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
      tag:      "v0.10.0",
      revision: "f92b26475274a0261eab536737a51177041aaf50"
  license "GPL-2.0-only"
  head "https://github.com/charlie0129/batt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "416a406ea1d2cbee93dd4d9e63826ec6246c2fb6499bdea6e853765734830eb9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06f367dc07d1a7f0d795f83429e1dc2f7efeb135e1bffc59941cf5c31d5b372c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d9844dfd56fd9869400222390b88f6b07e4ec4fc060e0028f2bb63377ec62db"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # GOTAGS is set to disable built-in install/uninstall commands when building for Homebrew.
    system "make", "GOTAGS=brew", "VERSION=v#{version}"
    bin.install "bin/batt"

    generate_completions_from_executable(bin/"batt", shell_parameter_format: :cobra)
  end

  def caveats
    <<~EOS
      The batt service must be running as root before most of batt's commands will work.
    EOS
  end

  service do
    run [opt_bin/"batt", "daemon", "--log-level=debug", "--always-allow-non-root-access", "--config=#{etc}/batt.json"]
    keep_alive true
    require_root true
    process_type :interactive
    log_path var/"log/batt.log"
    error_log_path var/"log/batt.log"
  end

  test do
    # batt is only meaningful on Mac laptops. There is not much we can test
    # in a VM.
    assert_match "version=v#{version}", # Shows version
      shell_output("#{bin}/batt daemon --config=#{etc}/batt.json 2>&1", 1) # Non-root daemon exits with 1
    assert_match "batt daemon is not running",
      shell_output("#{bin}/batt status 2>&1", 1) # Cannot connect to daemon
  end
end
