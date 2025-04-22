class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "d602ddf2ab45ecaa6ec50815f4468fdeafccfb979ac5191e541a53b54b658e33"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8173dc09953993aae822147c4929171be223c97cda7241a00d86a3bbec556b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8173dc09953993aae822147c4929171be223c97cda7241a00d86a3bbec556b08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8173dc09953993aae822147c4929171be223c97cda7241a00d86a3bbec556b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "734b7c223f2a2c32694c7ebbbb5448c43fe87612d7fac5257c2a7a4470a9a1e4"
    sha256 cellar: :any_skip_relocation, ventura:       "734b7c223f2a2c32694c7ebbbb5448c43fe87612d7fac5257c2a7a4470a9a1e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e3ef45b751679ee4fb0e5d18ccb8f01ed166f0facb33d517456ef4528056157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8173dc09953993aae822147c4929171be223c97cda7241a00d86a3bbec556b08"
  end

  depends_on "gnupg" => :test
  depends_on "pass"
  depends_on "python@3.13"

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
