class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.6.5.tar.xz"
  sha256 "337a39767e6a8e69b2bcc549f27ff3915efacea57e5334c6068fcb72331d7315"
  revision 1

  head "https://git.zx2c4.com/password-store", :using => :git

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "41f0fe499d0d20df5962ef0f51b18445eacd26705d4c4eb2e2283fc8f911a6ca" => :el_capitan
    sha256 "a304dad35621f226856262d16fb3045f3ba424c255ff434eed27ee4543cd93ed" => :yosemite
    sha256 "ce1f893a53205dc65cd857025a54067a36e37468948922114c46602da66f1bb4" => :mavericks
  end

  depends_on "pwgen"
  depends_on "tree"
  depends_on "gnu-getopt"
  depends_on :gpg => :run

  def install
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "contrib"
    zsh_completion.install "src/completion/pass.zsh-completion" => "_pass"
    bash_completion.install "src/completion/pass.bash-completion" => "password-store"
    fish_completion.install "src/completion/pass.fish-completion" => "pass.fish"
  end

  test do
    # Note that test do is always in temporary path, with HOME captured,
    # so this doesn't interfere with a user's pre-existing keychain.
    (testpath/"batchgpg").write <<-EOS.undent
    Key-Type: RSA
    Key-Length: 2048
    Subkey-Type: RSA
    Subkey-Length: 2048
    Name-Real: Testing
    Name-Email: testing@foo.bar
    Expire-Date: 1d
    Passphrase: brew
    %commit
    EOS
    system "gpg2", "--batch", "--gen-key", "batchgpg"

    system bin/"pass", "init", "Testing"
    system bin/"pass", "generate", "Email/testing@foo.bar", "15"
    assert File.exist?(".password-store/Email/testing@foo.bar.gpg")
  end
end
