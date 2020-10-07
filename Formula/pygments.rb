class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "https://pygments.org/"
  url "https://files.pythonhosted.org/packages/e2/07/25bd93c9c0175adfa5fb1513a20b25e7dd6c9a67c155e19b11b5f3662104/Pygments-2.7.1.tar.gz"
  sha256 "926c3f319eda178d1bd90851e4317e6d8cdb5e292a3386aac9bd75eca29cf9c7"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/pygments/pygments.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d2ce36688ac7270295bffffcc606c0f0068ac7bbc323e0b28f3fcf94d8125afd" => :catalina
    sha256 "1ad894a00625ed6b8eb1c9372fc08e3f33cbf22bb74daaa7340eaaa94056446e" => :mojave
    sha256 "538dd6dffdaf7327775f0b5df1dd08878338c225b58296f9164795df17b1960c" => :high_sierra
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
