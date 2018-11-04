class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.20.tar.gz"
  sha256 "13e2170c992ed3285163ea53373bc34abdd7ed64d0f901d5af714e8a83566795"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfe1fb259e9cda1064679090ed2f89d9d322c1c7441018771846eb84798ed1ce" => :mojave
    sha256 "38e9363152bcc1d8f7ce243b9e9dcce4d63600fe475419a82cb1b484b7e34d42" => :high_sierra
    sha256 "f21da8393f19e057358e980add91d6f8aeb0918e9edccc1aac0936c4e2fb61d7" => :sierra
    sha256 "81006d60c39fe62a30f6de76f000d027414e936351b5e571d6e55006c959246c" => :el_capitan
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
