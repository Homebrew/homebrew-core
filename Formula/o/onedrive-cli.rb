class OnedriveCli < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/refs/tags/v2.5.6.tar.gz"
  sha256 "dda49ae9d0c042205ae8f375704c154fc7a9fc88aa21e307e7d83aa1954ad57e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "ffed268ca06c52fc34d1c0936ff9874541ea0edd765e11c0ecd327cc0f252d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "59db371d3d004e737c0ebe46f81fe830dc70ce81d4cac2ec1c2559a6f30da02b"
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
