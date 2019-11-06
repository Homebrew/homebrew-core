class Pygments < Formula
  include Language::Python::Virtualenv

  desc "Generic syntax highlighter"
  homepage "http://pygments.org/"
  url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
  sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"

  head "https://bitbucket.org/birkenfeld/pygments-main", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "d6d30984eae722a0bde57e6590e0c89121cf340f050f0ac8a995212d622173b5" => :catalina
    sha256 "778197007f7c9dda3f9121d7ee3aa0014002665b40dae5dae14e07f504162062" => :mojave
    sha256 "ab35a224a347be5ad296ac3ee12e69e917ca34f7f47a7ef948aa81ca1d40e710" => :high_sierra
    sha256 "931c35edfec89042b2fc1c97256055060dd92fc60c699a883a204caf66930bae" => :sierra
  end

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
