class OnedriveCli < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://abraunegg.github.io"
  url "https://github.com/abraunegg/onedrive/archive/refs/tags/v2.5.12.tar.gz"
  sha256 "7d23679f244b44ab4ff015e940795ec8bfd24de97bea469d6a31f110ca12d61d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_linux:  "a79782fe7f01b9d129aa89db886795361e3957a4a8028f1c321f2a69bd83d081"
    sha256 cellar: :any, x86_64_linux: "d700b0fb2253da9dd2d793305384d8e5e4f167895739b5f82f39af9d766d8816"
  end

  depends_on "ldc" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "dbus"
  depends_on :linux
  depends_on "sqlite"
  depends_on "systemd"

  allow_network_access! :test

  def install
    system "./configure", "--with-systemdsystemunitdir=no", *std_configure_args
    system "make", "install"
    bash_completion.install "contrib/completions/complete.bash" => "onedrive"
    zsh_completion.install "contrib/completions/complete.zsh" => "_onedrive"
    fish_completion.install "contrib/completions/complete.fish" => "onedrive.fish"
  end

  service do
    run [opt_bin/"onedrive", "--monitor"]
    keep_alive true
    error_log_path var/"log/onedrive.log"
    log_path var/"log/onedrive.log"
    working_dir Dir.home
  end

  test do
    assert_match <<~EOS, pipe_output("#{bin}/onedrive 2>&1", "")
      Using IPv4 and IPv6 (if configured) for all network operations
      Attempting to contact the Microsoft OneDrive Service
      Successfully reached the Microsoft OneDrive Service
    EOS
  end
end
