class Proselint < Formula
  include Language::Python::Virtualenv

  desc "Linter for prose"
  homepage "https://github.com/amperser/proselint"
  url "https://files.pythonhosted.org/packages/58/66/bc509b61df9a317689f6a87679f2f9f625f6f02dfb9d0e220bd41f121f07/proselint-0.14.0.tar.gz"
  sha256 "624964272bea14767e5df2561d87dd30767938c8cb52fb23585bc37580680e86"
  license "BSD-3-Clause"
  head "https://github.com/amperser/proselint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "216e04dbf6fed2c35a614a601a636232030fc54b9e51901eaad0d8811f555ebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2b1430dfe879f22305bffae6be7c84a4fe347e8cf1e2f09d1b19221695bb083"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fef3e97aaabdb8ebdd6e0b30ce5d9ef5b25d602db9f34a94d8734145a8110d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b480d58b0ca4ea57721e71354f9e425d4bd8d47c68e8481c8f30a62076cfe4f"
    sha256 cellar: :any_skip_relocation, ventura:        "360ae0ab57b3aa09c663b71fd6c53e9cc873a925fb580d0bbb91ff3324607f3c"
    sha256 cellar: :any_skip_relocation, monterey:       "b9d117899a3c76dcc4a8a2983778e7ca306035c56411773a0adf30fea0b2a937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fd0442ce8777f0925f5da36659d9f6fccdc2865c728f39d370114af3def79a0"
  end

  depends_on "python@3.12"

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
