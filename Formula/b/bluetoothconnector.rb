class Bluetoothconnector < Formula
  desc "Connect and disconnect Bluetooth devices"
  homepage "https://github.com/lapfelix/BluetoothConnector"
  url "https://github.com/lapfelix/BluetoothConnector/archive/refs/tags/2.1.0.tar.gz"
  sha256 "cbb192e5f94da27408bd8306a25e11bbffd643d916f6a03d532f83a229281f77"
  license "MIT"
  head "https://github.com/lapfelix/BluetoothConnector.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a09325ad64ca0a614f87d18aa6e54474d841d985a94bba2f7f7c15950a985c8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e8786893183eba145ea2282b69540bd3c5b331decd4587090e94ac8b828e050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fe88b3f3feca2d6bc8c39cb06af98f81ee42a04fac836873f80b06d87cc37d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f1e8d18ce7e2ee41a70c1a8d952a91404e4701725075e56f87bb063416880b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0094ab63b0f1d951007bbe29ec8413e1cf4548687fde0f051f2fdc8ddc7b754a"
    sha256 cellar: :any_skip_relocation, ventura:       "360733d6b564009fa2fde910ab9fd67baddd172e2a3763fda858db7ce0626eb4"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--static-swift-stdlib"
    bin.install ".build/release/BluetoothConnector"
  end

  test do
    if MacOS.version >= :sonoma && ENV["HOMEBREW_GITHUB_ACTIONS"]
      # We cannot test any useful command since Sonoma as OS privacy restrictions
      # will wait until Bluetooth permission is either accepted or rejected.
      # Since even `--help` needs permissions, we just check process is still running.
      pid = fork { exec bin/"BluetoothConnector" }
      begin
        sleep 5
        Process.getpgid(pid)
      ensure
        Process.kill("TERM", pid)
      end
    else
      shell_output("#{bin}/BluetoothConnector", 64)
      output_fail = shell_output("#{bin}/BluetoothConnector --connect 00-00-00-00-00-00", 252)
      assert_equal "Not paired to device\n", output_fail
    end
  end
end
