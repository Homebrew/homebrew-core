class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/v1.4.0.tar.gz"
  sha256 "e7ff68b074ad25f61cac0a8f291fec8cdb9b701c32fbde37e1b5bfa8f2211c6d"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa1908081936c96726efc978ebda0bb925774fad4c2db387ed68cef69deae138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "525dbef2e267f434fea8d53aec68e569e9f6fca9768c8d06e89a83aeaeec9f00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46d1f3cd4408ed377783b6c3e208b8e4b99e510a09c0a0a1b29b8b5f153ee756"
    sha256 cellar: :any_skip_relocation, ventura:        "8ac8045fc1950475ae41c755bdcf8393e718c1646e9e1028e0c8b17e180dda9c"
    sha256 cellar: :any_skip_relocation, monterey:       "ed2127fc69d08a420a5bd06ed99422c5f4340ce32d74ca6b77fbf427fcd24eba"
    sha256 cellar: :any_skip_relocation, big_sur:        "8daa0b2b079f9d4d105536769ce5e4a9012e3106997f4c4411168206634c7aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "519db42f0f2d80890ee442287fe642e4c5cfdcdab470e5b162ba9180e0e4952f"
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
