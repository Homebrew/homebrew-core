class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3b0cda7a5eae2e93cc1ccec0ea02716db5a2ce3105c6d631f20fa20152b7a163"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc49479ad804837704f42f901f352a8b1b12c05eca21abb8bc20c51022cd51a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc49479ad804837704f42f901f352a8b1b12c05eca21abb8bc20c51022cd51a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "352862920179610c7c5414fff296d3f5c373f0cc983bbddc42c64a49306f8bbb"
    sha256 cellar: :any_skip_relocation, ventura:       "352862920179610c7c5414fff296d3f5c373f0cc983bbddc42c64a49306f8bbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1317d6bf961f2a4ca1b114e526d292153b332bbebba6c8b78682f075a04154c5"
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
