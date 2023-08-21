class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/v1.3.0.tar.gz"
  sha256 "9600bba2e7ac389a45a8222478c4fb2a4b1722682868df7dc7daa991828d851c"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "096a1079c9aff6cd26748511bb063471d213ba7864f2c5f8ef35b3a72c721c6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98cbfad039d46dae12c8d9b047f67cddc1861ef2e1bd9a9c4dd729ba0e994844"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f9d4fd7aafb8714b71e6f7c0a71afe9def4e380d5fd7a8da11baeea61f745cf"
    sha256 cellar: :any_skip_relocation, ventura:        "6fe0bf8854884e104906d3e906e3f91b64f7ce7a001f6ecc85b65e8283a3ee6c"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd8680f0b5c9c1bd32ab74bc1ace7cef5ace2d382c240509abdcd04f9d8c188"
    sha256 cellar: :any_skip_relocation, big_sur:        "67830f4ad1bd4b50186ea747685cadd738d7c3b471ac030b818181b0f9a6608d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2330b6069770b1620418485c1436fe348e9acbd74bf4b49e12ffabf54b1f009"
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
