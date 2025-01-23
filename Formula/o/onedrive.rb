class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "1b385c4f3d34d703e2ed095575244ea03df4bb41fcc7d0d8fbd6366534f2ca6a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "052165904a9d146ef4b7b8e46b5470b94b98669c9b051bf5ce157d133ec9f0c0"
  end

  depends_on "ldc" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
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
