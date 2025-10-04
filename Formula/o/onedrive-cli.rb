class OnedriveCli < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/refs/tags/v2.5.7.tar.gz"
  sha256 "b8526bf8b0ad98967f17634271eef4435ace5c1d116ada7d2e2809b84837be4c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a5ed006c9b774411f9210fa338fedc66e3082f66a665cb666db551f00c815b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "16eb51d8aef5551baaf3f2ed37adbb33cffcc97abbfaedda93322bcc2e367ccd"
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
