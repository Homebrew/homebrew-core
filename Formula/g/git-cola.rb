class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/d7/e6/9272e207377034aea65b463a60c76ea764b987bf48bbb55744ea9124f85b/git-cola-4.4.1.tar.gz"
  sha256 "ae8464d202cd917b204b1b0f113609a8163ea5678396b88ab9320a944afe6cc7"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab063bde7c7444d98a71ae1eece87c445e1bb1455ee9e34426d9f285ecb13bbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd19bcfeb8435a74f114c9529d9ebff448edb8332e4eeadb97fee8715ada0948"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8b9448ffa11630093ebf36be2f8d8dcbda7d03026f901353abcc35556976970"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d6f47846de21bd207b8063e2b7fde71aa39f54375639fc51a35686c1d3a8fae"
    sha256 cellar: :any_skip_relocation, ventura:        "9b23c2bf7fed81954f2a0ee0e1f0088fcc6d1e8bfc40e7722d8aaa18196bcca1"
    sha256 cellar: :any_skip_relocation, monterey:       "662302ada7f6d38f9ca230a95a131b2b79248c21e06838713aedbb27168e3b3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f39256ea2ee68930706b372987e3c9ad980ddd912581e1fba11a22ca75d9aa17"
  end

  depends_on "pyqt"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python@3.12"

  resource "qtpy" do
    url "https://files.pythonhosted.org/packages/eb/9a/7ce646daefb2f85bf5b9c8ac461508b58fa5dcad6d40db476187fafd0148/QtPy-2.4.1.tar.gz"
    sha256 "a5a15ffd519550a1361bdc56ffc07fda56a6af7292f17c7b395d4083af632987"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
