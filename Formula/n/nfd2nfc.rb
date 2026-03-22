class Nfd2nfc < Formula
  desc "Convert filesystem entry names from NFD to NFC for cross-platform compatibility"
  homepage "https://github.com/elgar328/nfd2nfc"
  url "https://github.com/elgar328/nfd2nfc/archive/refs/tags/v2.0.7.tar.gz"
  sha256 "ea53755802bbd85aa52e4d56d251c20bbf490bce39c28551852b2f7f02e042cf"
  license "MIT"
  head "https://github.com/elgar328/nfd2nfc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4846e44a1c14c1b76eef72df36adb7ba84fe51a8f20da6f82439b1c0b610f90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f385ac54a2ac690e578a37685256407726df2fa8912344c7bfc557374b9095f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a71ac65f6c1cb86807bba5643e9fc64f714c22f9908a905ff2f1505cc8cecae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "287142bdaba3ce58a5a65850241522ad04539a1f63026b3aad0e26e6114a04fa"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "nfd2nfc")
    system "cargo", "install", *std_cargo_args(path: "nfd2nfc-watcher")
  end

  test do
    # 1. Version checks
    assert_match version.to_s, shell_output("#{bin}/nfd2nfc --version")
    assert_match version.to_s, shell_output("#{bin}/nfd2nfc-watcher --version")

    # 2. Watcher functional test
    watch_dir = testpath/"watch"
    ignore_dir = watch_dir/"ignored"
    mkdir_p ignore_dir

    config_dir = testpath/".config/nfd2nfc"
    mkdir_p config_dir
    (config_dir/"config.toml").write <<~TOML
      [[paths]]
      path = "#{watch_dir}"
      action = "watch"
      mode = "recursive"

      [[paths]]
      path = "#{ignore_dir}"
      action = "ignore"
      mode = "recursive"
    TOML

    spawn bin/"nfd2nfc-watcher" do |watcher_pid|
      sleep 2

      # NFD name: Korean "가" decomposed (ᄀ + ᅡ)
      nfd_name = "\u{1100}\u{1161}"
      # NFC name: Korean "가" composed
      nfc_name = "\u{AC00}"

      # File in watch_dir should be converted NFD→NFC
      (watch_dir/nfd_name).write("test")
      sleep 1
      assert_path_exists watch_dir/nfc_name

      # File in ignore_dir should NOT be converted (remains NFD)
      (ignore_dir/nfd_name).write("test")
      sleep 1
      assert_path_exists ignore_dir/nfd_name
    ensure
      Process.kill("TERM", watcher_pid)
      Process.wait(watcher_pid)
    end

    # 3. TUI Config tab test
    require "pty"
    mkdir_p testpath/"Library/LaunchAgents"
    # Pre-create dummy plist so TUI skips launchctl bootstrap
    (testpath/"Library/LaunchAgents/io.github.elgar328.nfd2nfc.plist").write("")

    PTY.spawn(bin/"nfd2nfc") do |r, w, _pid|
      # Switch to Config tab, delete both entries, save, quit
      "2ddsq".each_char { |key| w.write(key) }
      begin
        r.read
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    # All entries deleted — no [[paths]] should remain
    refute_match "[[paths]]", (config_dir/"config.toml").read
  end
end
