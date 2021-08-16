class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/v2.4.13.tar.gz"
  sha256 "6cb903ec14be249caa13c04a4fbba9a431041c224e7d815798a94f7b93861263"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f75d1d472950cd24ba3fdaa1c59db77583888435cd2969bd268679e906d3b769"
  end

  depends_on "ldc" => :build
  depends_on "pkg-config" => :build
  depends_on "curl"
  depends_on :linux
  depends_on "sqlite"
  depends_on "systemd"

  def install
    system "./configure", *std_configure_args
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
    working_dir ENV["HOME"]
  end

  test do
    assert_match <<~EOS, pipe_output("#{bin}/onedrive 2>&1", "")
      Enter the response uri: Invalid uri
      Could not initialize the OneDrive API
    EOS
  end
end
