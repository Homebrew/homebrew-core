class PassGitHelper < Formula
  include Language::Python::Virtualenv

  desc "Git credential helper interfacing with pass"
  homepage "https://github.com/languitar/pass-git-helper"
  url "https://github.com/languitar/pass-git-helper/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "98287dca8b75376e1829f8e0fffd7db66030ad94bf81f824312b0425d42bd64c"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b86c6b2b028740ecf4ff353b021949d7c399734c82e25a6aceb8003fb085cd06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b86c6b2b028740ecf4ff353b021949d7c399734c82e25a6aceb8003fb085cd06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b86c6b2b028740ecf4ff353b021949d7c399734c82e25a6aceb8003fb085cd06"
    sha256 cellar: :any_skip_relocation, sonoma:        "8302608b32535b74bf1189b15c18043ab614bed447590555b7039548866d80b9"
    sha256 cellar: :any_skip_relocation, ventura:       "8302608b32535b74bf1189b15c18043ab614bed447590555b7039548866d80b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b86c6b2b028740ecf4ff353b021949d7c399734c82e25a6aceb8003fb085cd06"
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
