class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
  sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  license "BSD-2-Clause"
  head "https://github.com/pygments/pygments.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a3f3b461647e5a27f28be74638a0a14f075ecf6c15c3bf86fb8967a574589f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa0453988908f7898bcb6cba2983f0f741c119466a52ce475d3509c21b273029"
    sha256 cellar: :any_skip_relocation, catalina:      "bbf8057e41df8d871afc02c4dce7904e1e21da7c67b52c03b4e8a8dc39b0b83e"
    sha256 cellar: :any_skip_relocation, mojave:        "1328dcbfbdd825c547c6bc4e181587afd6a05a8d5e10c11d2c3169d9d452a29a"
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
