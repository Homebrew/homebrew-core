class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
  sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4808dcffb3c6d546a56d04ec28b96eb27345f54d0c146b3bcadf6b617fabaff"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b47aad9d600099fcc9d88bb76d2762c7e7af5c83d8d7bae1330d7a165e2c47f"
    sha256 cellar: :any_skip_relocation, catalina:      "3b47aad9d600099fcc9d88bb76d2762c7e7af5c83d8d7bae1330d7a165e2c47f"
    sha256 cellar: :any_skip_relocation, mojave:        "3b47aad9d600099fcc9d88bb76d2762c7e7af5c83d8d7bae1330d7a165e2c47f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b55e1bd3d8a36ef13ced971208ed46485c6d760d1cc7f08cc4d02f835fc5554"
  end

  depends_on "python@3.9"

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
