class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
  sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5305b796d4c8118bfe3e186adb9726df52be21dd085edd99e934ec49bf16e40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5305b796d4c8118bfe3e186adb9726df52be21dd085edd99e934ec49bf16e40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5305b796d4c8118bfe3e186adb9726df52be21dd085edd99e934ec49bf16e40"
    sha256 cellar: :any_skip_relocation, sonoma:         "c5305b796d4c8118bfe3e186adb9726df52be21dd085edd99e934ec49bf16e40"
    sha256 cellar: :any_skip_relocation, ventura:        "c5305b796d4c8118bfe3e186adb9726df52be21dd085edd99e934ec49bf16e40"
    sha256 cellar: :any_skip_relocation, monterey:       "c5305b796d4c8118bfe3e186adb9726df52be21dd085edd99e934ec49bf16e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d0ad45bd306af2760a03127431c43846a8df9e2f49daa4ee14eaab1c62dc47b"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
      print(os.getcwd())
    EOS

    system bin/"pygmentize", "-f", "html", "-o", "test.html", testpath/"test.py"
    assert_predicate testpath/"test.html", :exist?
  end
end
