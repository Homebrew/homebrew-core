class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
  sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4808dcffb3c6d546a56d04ec28b96eb27345f54d0c146b3bcadf6b617fabaff"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b47aad9d600099fcc9d88bb76d2762c7e7af5c83d8d7bae1330d7a165e2c47f"
    sha256 cellar: :any_skip_relocation, catalina:      "3b47aad9d600099fcc9d88bb76d2762c7e7af5c83d8d7bae1330d7a165e2c47f"
    sha256 cellar: :any_skip_relocation, mojave:        "3b47aad9d600099fcc9d88bb76d2762c7e7af5c83d8d7bae1330d7a165e2c47f"
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
