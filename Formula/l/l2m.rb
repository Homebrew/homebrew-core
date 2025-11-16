class L2m < Formula
  desc "AI-powered legacy code modernization tool"
  homepage "https://github.com/astrio-ai/l2m"
  url "https://files.pythonhosted.org/packages/source/l/l2m/l2m-0.2.0.tar.gz"
  sha256 "ecf3e100bdab0c552303fc56dc66f213043a3ce0de03b8a3005c901c2a8ecbde"
  license "Apache-2.0"
  head "https://github.com/astrio-ai/l2m.git", branch: "main"

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/l2m", "--version"
  end
end
