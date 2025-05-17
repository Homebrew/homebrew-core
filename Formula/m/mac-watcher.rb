class MacWatcher < Formula
  desc "Monitor Mac activity with email alerts when system wakes from sleep"
  homepage "https://github.com/ramanaraj7/mac-watcher"
  url "https://github.com/ramanaraj7/mac-watcher/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a53d8bf8a8c3c18471b5a08bc1991bd3561ab398c7a409c8a170b8023c891228"
  license "MIT"

  depends_on "imagesnap"
  depends_on "jq"
  depends_on "sleepwatcher"

  def install
    bin.install "bin/mac-watcher"
    pkgshare.install "share/mac-watcher/config.sh"
    pkgshare.install "share/mac-watcher/monitor.sh"
    pkgshare.install "share/mac-watcher/setup.sh"
    chmod 0755, pkgshare/"config.sh"
    chmod 0755, pkgshare/"monitor.sh"
    chmod 0755, pkgshare/"setup.sh"
  end

  def post_install
    system bin/"mac-watcher", "--dependencies"
  end

  def caveats
    <<~EOS
      To complete setup, run:
        mac-watcher --setup
        mac-watcher --config (optional, to customize settings)
      Then start the sleepwatcher service:
        brew services start sleepwatcher
      To test functionality without waiting for a wake event:
        mac-watcher --test
      The setup process creates these user files:
        ~/.wakeup (wake detection script)
        ~/.config/monitor.conf (default configuration)
    EOS
  end

  test do
    system bin/"mac-watcher", "--help"
  end
end
