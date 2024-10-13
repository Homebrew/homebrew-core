class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "https://github.com/amperser/proselint"
  url "https://files.pythonhosted.org/packages/58/66/bc509b61df9a317689f6a87679f2f9f625f6f02dfb9d0e220bd41f121f07/proselint-0.14.0.tar.gz"
  sha256 "624964272bea14767e5df2561d87dd30767938c8cb52fb23585bc37580680e86"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2127a0808d77df7d5ff5035bd1406036100445e831c6c728d3367ad390a45af1"
  end

  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/proselint --compact -", "John is very unique.")
    assert_match "Comparison of an uncomparable", output
  end
end
