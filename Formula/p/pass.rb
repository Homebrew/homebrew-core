class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.7.4.tar.xz"
  sha256 "cfa9faf659f2ed6b38e7a7c3fb43e177d00edbacc6265e6e32215ff40e3793c0"
  license "GPL-2.0-or-later"
  head "https://git.zx2c4.com/password-store.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "98bd9949756576685149b0bba825a0d4a12efc5f256d703236a09e24fb6ab2b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "28e5b23335b5260675224af5d330a5d4f3b5e3d9be5f9491c68dbdb48ab8a6fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14e3206a94f04e911f0168b7e458f0149b8c42cd34014a113610431d2a142e1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e3206a94f04e911f0168b7e458f0149b8c42cd34014a113610431d2a142e1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14e3206a94f04e911f0168b7e458f0149b8c42cd34014a113610431d2a142e1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1132f363a63efb874ebf98f406dcc6f9346496b10b0a3b3c2063b447c8035180"
    sha256 cellar: :any_skip_relocation, ventura:        "1132f363a63efb874ebf98f406dcc6f9346496b10b0a3b3c2063b447c8035180"
    sha256 cellar: :any_skip_relocation, monterey:       "1132f363a63efb874ebf98f406dcc6f9346496b10b0a3b3c2063b447c8035180"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "22b1e65c5e116f21af96530d78f73e8b698debaec80c2b078d71c031895cc1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3104f2584abf3c35e811152282541832cc3e672d8b28024ee8d77d49cca172"
  end

  depends_on "gnupg"
  depends_on "qrencode"
  depends_on "tree"

  on_macos do
    depends_on "gnu-getopt"
  end

  def install
    system "make", "PREFIX=#{prefix}", "WITH_ALLCOMP=yes", "BASHCOMPDIR=#{bash_completion}",
                   "ZSHCOMPDIR=#{zsh_completion}", "FISHCOMPDIR=#{fish_completion}", "install"
    inreplace bin/"pass",
              /^SYSTEM_EXTENSION_DIR=.*$/,
              "SYSTEM_EXTENSION_DIR=\"#{HOMEBREW_PREFIX}/lib/password-store/extensions\""
    elisp.install "contrib/emacs/password-store.el"
    pkgshare.install "contrib"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system bin/"pass", "init", "Testing"
      assert_match "The generated password for", shell_output("#{bin}/pass generate Email/testing@foo.bar 15")
      assert_path_exists testpath/".password-store/Email/testing@foo.bar.gpg"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
