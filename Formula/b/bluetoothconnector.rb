class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/refs/tags/2.1.0.tar.gz"
  sha256 "cbb192e5f94da27408bd8306a25e11bbffd643d916f6a03d532f83a229281f77"
  license "MIT"
  head "https://github.com/lapfelix/BluetoothConnector.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "545a4128d0728c2a20f69c6e2863eeb8abf2c101da2e865df4e53e6ef64d9830"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e9f16794456553e1bb96608e579c0fcdb6930b793a2f6135a3113d3bf1072e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61cd24ebb1d29f0f3f9cfe2bb890bd29aacedb8d43a035d422566a4552670b70"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :ventura # swift 5.9+

  def install
    system "swift", "build", *std_swift_args
    bin.install ".build/release/BluetoothConnector"
  end

  test do
    if ENV["HOMEBREW_GITHUB_ACTIONS"]
      # OS privacy restrictions may block the process on the Bluetooth permission prompt,
      # so only check the usage exit code when it actually ran to completion.
      pid = spawn bin/"BluetoothConnector"
      sleep 5
      if Process.wait(pid, Process::WNOHANG)
        assert_equal 64, $CHILD_STATUS.exitstatus
      else
        Process.kill("TERM", pid)
        Process.wait(pid)
      end
    else
      shell_output("#{bin}/BluetoothConnector", 64)
      output_fail = shell_output("#{bin}/BluetoothConnector --connect 00-00-00-00-00-00", 252)
      assert_equal "Not paired to device\n", output_fail
    end
  end
end
