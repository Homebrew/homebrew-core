class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/v1.4.0.tar.gz"
  sha256 "e7ff68b074ad25f61cac0a8f291fec8cdb9b701c32fbde37e1b5bfa8f2211c6d"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdc265cc693c80244970842b29a23b10bcac4e94599cd2297573ccabe203800e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b3de00c73f481bc8b94a6583c7876456b4d8a1012c5d04c23650fa756fefe24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b4058dc34bd143523ba63508fedc3c134ff2b32849760749e311f22dda2354c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ab93883a4c6fad9590825c56b91ead41eb2bc5d26f5eb8dcdf91bc080dfd562"
    sha256 cellar: :any_skip_relocation, ventura:        "244c7b676c2a9c4a86ccd0c65049c04f4287b57ded1b5606371c146846be91bb"
    sha256 cellar: :any_skip_relocation, monterey:       "5e15d0b0029bd93e59274db88413b9c7cf80eafece3f5ebe09027507383d2809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e79aba73f7d62ef27c71b6b8ae888721c89ac4ab919c1f2ddc0af9817c308ab8"
  end

  depends_on "gnupg" => :test
  depends_on "pass"
  depends_on "python@3.12"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Generate temporary GPG key for use with pass
    pipe_output("#{Formula["gnupg"].opt_bin}/gpg --generate-key --batch", <<~EOS, 0)
      %no-protection
      %transient-key
      Key-Type: RSA
      Name-Real: Homebrew Test
    EOS

    system "pass", "init", "Homebrew Test"

    pipe_output("pass insert -m -f homebrew/pass-git-helper-test", <<~EOS, 0)
      test_password
      test_username
    EOS

    (testpath/"config.ini").write <<~EOS
      [github.com*]
      target=homebrew/pass-git-helper-test
    EOS

    result = pipe_output("#{bin}/pass-git-helper -m #{testpath}/config.ini get", <<~EOS, 0)
      protocol=https
      host=github.com
      path=homebrew/homebrew-core
    EOS

    assert_match "password=test_password\nusername=test_username", result
  end
end
