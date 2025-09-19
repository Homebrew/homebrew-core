class OnedriveCli < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "dda49ae9d0c042205ae8f375704c154fc7a9fc88aa21e307e7d83aa1954ad57e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2c54f494cf6d5a696591c48c47beec7c26eaee439339190903fe13a3a9bb5830"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e724ac164f75c6bf48b24b288e135649c55f80bc732fcf2761e8cfb0ec0f33c0"
  end

  depends_on "ldc" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "dbus"
  depends_on :linux
  depends_on "sqlite"
  depends_on "systemd"

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
      Attempting to contact Microsoft OneDrive Login Service
      Successfully reached Microsoft OneDrive Login Service
    EOS
  end
end
