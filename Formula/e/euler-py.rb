class EulerPy < Formula
  include Language::Python::Virtualenv

  desc "Project Euler command-line tool written in Python"
  homepage "https://github.com/iKevinY/EulerPy"
  url "https://files.pythonhosted.org/packages/a6/41/f074081bc036fbe2f066746e44020947ecf06ac53b6319a826023b8b5333/EulerPy-1.4.0.tar.gz"
  sha256 "83b2175ee1d875e0f52b0d7bae1fb8500f5098ac6de5364a94bc540fb9408d23"
  license "MIT"
  revision 3
  head "https://github.com/iKevinY/EulerPy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d2331698d82ebb953c1b63323ed4a1c4a5dc5ca69b6213ae24590a67e3569c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d2331698d82ebb953c1b63323ed4a1c4a5dc5ca69b6213ae24590a67e3569c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d2331698d82ebb953c1b63323ed4a1c4a5dc5ca69b6213ae24590a67e3569c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d2331698d82ebb953c1b63323ed4a1c4a5dc5ca69b6213ae24590a67e3569c2"
    sha256 cellar: :any_skip_relocation, ventura:        "8d2331698d82ebb953c1b63323ed4a1c4a5dc5ca69b6213ae24590a67e3569c2"
    sha256 cellar: :any_skip_relocation, monterey:       "8d2331698d82ebb953c1b63323ed4a1c4a5dc5ca69b6213ae24590a67e3569c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22166d8bb4c8e96c7d2ff89f1d0da3cdfa1630c67bfddac76ba00f75dd0a978d"
  end

  depends_on "python@3.12"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  def install
    # Unpin old click version: https://github.com/iKevinY/EulerPy/commit/9923d2ee026608e33026909bb95c444724b08ba2
    inreplace "requirements.txt", "click==4.0", "click"
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/euler", "Y\n")
    assert_match 'Successfully created "001.py".', output
    assert_predicate testpath/"001.py", :exist?
  end
end
