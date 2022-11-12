class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/v1.2.0.tar.gz"
  sha256 "d9ab12d81e283411a65285a0030cbfef2548dc580631d2337628e57f10e463aa"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8c11dbf1e2273b0bcaf863fa031082e3854734a3544052de092a5b25391ca2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27cfc57aaac1a17fe4f30b90bbfe3ae7d39c47809d6423ed90649a8883adb093"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27cfc57aaac1a17fe4f30b90bbfe3ae7d39c47809d6423ed90649a8883adb093"
    sha256 cellar: :any_skip_relocation, monterey:       "e3b14e770794bc4196af2309299baed5841caaae70ebbdc4478bb4eaf831e85c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3b14e770794bc4196af2309299baed5841caaae70ebbdc4478bb4eaf831e85c"
    sha256 cellar: :any_skip_relocation, catalina:       "e3b14e770794bc4196af2309299baed5841caaae70ebbdc4478bb4eaf831e85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cafce9d5d691c50093ab12325a3756b1f8bc40c1a929cf20c397446fbdb54ae"
  end

  depends_on "gnupg" => :test
  depends_on "pass"
  depends_on "python@3.11"

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
