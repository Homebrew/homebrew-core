class OnedriveCli < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/refs/tags/v2.5.9.tar.gz"
  sha256 "2a1d28343e4f8fefe0129a4e8480b09bab5aec2697046fb3d03f34e18c0be4ab"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "577e3ed1302d2067ccfb821d3e8d158cd74b1a6e142a6e14f3aad8fa258e1ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "20dd338318165b4a44f7bc0e7511e0a58d6aabd407e7b32c962621dc854f8430"
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
      Attempting to contact the Microsoft OneDrive Service
      Successfully reached the Microsoft OneDrive Service
    EOS
  end
end
