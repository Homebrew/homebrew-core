class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/v1.1.1.tar.gz"
  sha256 "17a4c36d0fe67a7a4a709da3c0649d10efb02df266e62765661eac2ced4bc03d"
  license "LGPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "596a8169fd6f497d1bf3281c705e6b0ae8acfd32932aae43e48767e82dd3bbfa" => :big_sur
    sha256 "5b307f5511251caa62b883a7b6883e8c1fbc3592f781367191323c2318118c0d" => :arm64_big_sur
    sha256 "8119c8268a4b9340b0b13e58488c862f360b76dbd4f0979baa2ab18fbcb64ca7" => :catalina
    sha256 "ceea5bff46e7d2cdb714dd0b4801c21c3279706f7b3bdeccaf9a26e762c7954a" => :mojave
  end

  depends_on "gnupg" => :test
  depends_on "pass"
  depends_on "python@3.9"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
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
