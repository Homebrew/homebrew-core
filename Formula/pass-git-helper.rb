class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/v1.1.2.tar.gz"
  sha256 "4acfb486d0873014376383167792ee2b46926386718eb2331a1b4564576a2076"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a6b1bc4bd28d16ec0b55484f42072fc2458ea043d2354c97cd7272a51160ab2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a6b1bc4bd28d16ec0b55484f42072fc2458ea043d2354c97cd7272a51160ab2"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd61826747bde532d2b9e8898f75776d72b7eec02994d5ed4e2d0c42850cd93"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fd61826747bde532d2b9e8898f75776d72b7eec02994d5ed4e2d0c42850cd93"
    sha256 cellar: :any_skip_relocation, catalina:       "3fd61826747bde532d2b9e8898f75776d72b7eec02994d5ed4e2d0c42850cd93"
    sha256 cellar: :any_skip_relocation, mojave:         "3fd61826747bde532d2b9e8898f75776d72b7eec02994d5ed4e2d0c42850cd93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4eb72906bbc973d792d2378045213c85df621bca406ce06eb0cf0fce9d7e64"
  end

  depends_on "gnupg" => :test
  depends_on "pass"
  depends_on "python@3.10"

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
