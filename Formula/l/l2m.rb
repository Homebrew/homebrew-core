class L2m < Formula
  desc "AI-powered legacy code modernization tool"
  homepage "https://github.com/astrio-ai/l2m"
  # l2m should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/03/42/153c7c7f8fdd6ca124d183df7515b5113c77a34c24dd98bdf07bed70b64a/l2m-0.2.0.tar.gz"
  sha256 "ecf3e100bdab0c552303fc56dc66f213043a3ce0de03b8a3005c901c2a8ecbde"
  license "Apache-2.0"
  head "https://github.com/astrio-ai/l2m.git", branch: "main"

  no_autobump! because: :requires_manual_review

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    # Test version output
    assert_match version.to_s, shell_output("#{bin}/l2m --version")
  end
end
