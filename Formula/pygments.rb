class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/5d/9d/208733ccc91b1d2c2af7270ffe3def197504bd8da875bc3fa1dc75039795/Pygments-2.7.0.tar.gz"
  sha256 "2594e8fdb06fef91552f86f4fd3a244d148ab24b66042036e64f29a291515048"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "509010be01f39644658904cd9396824b6cee202083b4659d8dd7e03e7f8afd17" => :catalina
    sha256 "6c413d6695fc730fcc6e547e1de3bf55ed245f66059eebfa2e99a683b240dbe5" => :mojave
    sha256 "42cc8f55ba8f2ca0766f7d99b1921671ad6d6aa884f23f1fbe88192e92ec89cb" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    bash_completion.install "external/pygments.bashcomp" => "pygmentize"
    virtualenv_install_with_resources
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
