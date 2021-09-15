class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/83/0d/d8409c79412baa30717e6d18942251bc18d8cf43447b153f92056be99053/gcovr-5.0.tar.gz"
  sha256 "1d80264cbaadff356b3dda71b8c62b3aa803e5b3eb6d526a24932cd6660a2576"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f33208660cf97e15c0553b50fc95533761750b99cf612d7b469f02aaaa4080d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "04ecfd6d451d6d3e87a76d2eef8a47e6a6ce7157431055a1cf4debaf0afef246"
    sha256 cellar: :any_skip_relocation, catalina:      "2b21a8fc40832eb069b0183329d9b6848fdab864d25b9cb8c2ca5d6c43f14ccd"
    sha256 cellar: :any_skip_relocation, mojave:        "b5f15221d9e6689e617aa31a56cb8e4ea17b6969941a0c26fe28e9cd94d49831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aba343a506313d94d5291969fdc4dc055a93b7b5a71563d024843ec657aa0616"
  end

  depends_on "python@3.9"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system "cc", "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                 "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
