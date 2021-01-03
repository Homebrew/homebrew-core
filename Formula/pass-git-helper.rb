class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/v1.1.1.tar.gz"
  sha256 "17a4c36d0fe67a7a4a709da3c0649d10efb02df266e62765661eac2ced4bc03d"
  license "LGPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "11bbb8eadaa742fc42ef7459efa02608a4c9a3d23a3e78cf7d95f23a8bfa1e30" => :big_sur
    sha256 "13fde52069e92ffd9a31f1e02fea1c917317eb5288c42b62a5f26bde992a04c7" => :arm64_big_sur
    sha256 "16c381567a7d7584955dd3584ab6cdf73db6f27ba240b638e1e5e5a9a1157825" => :catalina
    sha256 "d3db9b4d99dc078897b3998d76abf4dee8e8236ee8c0addcbef1b9a49b693845" => :mojave
    sha256 "47647006f90c61081c40579fdbb3431398f8f67084b344b084f356558ead87f6" => :high_sierra
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
