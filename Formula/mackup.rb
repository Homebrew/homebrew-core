class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.20.tar.gz"
  sha256 "13e2170c992ed3285163ea53373bc34abdd7ed64d0f901d5af714e8a83566795"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7cecfa5b793bd91a0a2e805901e8506a8dffb639f5b65a91bd0cef6ce1b67b6" => :mojave
    sha256 "818122c8216d08dbb84697a31ec33bc8b76e6593fb8a035052dedfa3a60795ff" => :high_sierra
    sha256 "0605ebaca5eeb4a5b76b1975e7bed8c9dbd0898605decc19cffbf7204b9b9348" => :sierra
  end

  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
