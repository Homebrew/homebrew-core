class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/df/6f/764ca059e0eb06b69e1abed2c9a2cabe7dac72b336e2600615b38ea547a3/codespell-1.16.0.tar.gz"
  sha256 "bf3b7c83327aefd26fe718527baa9bd61016e86db91a8123c0ef9c150fa02de9"

  bottle do
    cellar :any_skip_relocation
    sha256 "adb1bc633bab65e7cd2f44a0b658cd83a3c3c2a00ac5d859c4b341be2aaf3018" => :catalina
    sha256 "577e71571fcefa1ef4edae6d790aa80e978afb21de6f12d232601885b0d30ff9" => :mojave
    sha256 "330c2359a5e5050d555d9f70c29add7d3e7c9554d89ed43607235a896453b461" => :high_sierra
    sha256 "b77254f7aee7303a2edabb0a780a78407e7d8c55a44e6a5c75c9dd799beba12d" => :sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 1)
  end
end
