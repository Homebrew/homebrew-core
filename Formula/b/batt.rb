class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
      tag:      "v0.9.0",
      revision: "84fd046b84998b8c05b8db53fef4fd90b2367b23"
  license "GPL-2.0-only"
  head "https://github.com/charlie0129/batt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52469b76f82f1b8e421f22275ff551819c5913ce166b7310ae72e72647c720cc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4260e000b05981702a69f24fd6d307c49586a088b94e5cad5935b10680013d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "315dc0f04f4a2d3d2b8c6f02aaa33f6861b0ad2ddc86ab967c8214b4e23264ad"
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
