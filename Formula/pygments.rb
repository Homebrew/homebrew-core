class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "http://pygments.org/"
  url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
  sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"

  head "https://bitbucket.org/birkenfeld/pygments-main", :using => :hg

  depends_on "python"

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
