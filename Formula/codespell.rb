class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/df/6f/764ca059e0eb06b69e1abed2c9a2cabe7dac72b336e2600615b38ea547a3/codespell-1.16.0.tar.gz"
  sha256 "bf3b7c83327aefd26fe718527baa9bd61016e86db91a8123c0ef9c150fa02de9"

  bottle do
    cellar :any_skip_relocation
    sha256 "aae637ce9ea085bea8fb28a9efbcfd26d0c89c25a2470cdbc2eddf0d8ec21059" => :mojave
    sha256 "88380ded56e033c18878f8d7ca53988becf56ca25f4062bdb3c4e931b41a5bbd" => :high_sierra
    sha256 "9901d26d021a711e529a5e197032cddb35c8f7919054aa3953403923a992debd" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 1)
  end
end
