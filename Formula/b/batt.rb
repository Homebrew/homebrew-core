class Batt < Formula
  desc "Control and limit battery charging on Apple Silicon MacBooks"
  homepage "https://github.com/charlie0129/batt"
  url "https://github.com/charlie0129/batt.git",
      tag:      "v0.8.0",
      revision: "f25fef31ee247bbe81df468cb2523a8015c12f12"
  license "GPL-2.0-only"
  head "https://github.com/charlie0129/batt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c707d1a745bd58203718e50e4e587a7196529ab9c9f1203129f9c930c63a8d55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8377932f77ea50bdf6b2637664b48006f1f2bc04464332c7b35f1133503ef22c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad2aa81da082815acdd36d570f831947489e244086198e0893bb1b5ed8189c52"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

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
