class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/19/6d/2942ab8c693f2b9f97052d6a6de4c27323a3bd85af7d062dc5bd3a2a9604/gcovr-6.0.tar.gz"
  sha256 "8638d5f44def10e38e3166c8a33bef6643ec204687e0ac7d345ce41a98c5750b"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0621f715f63d20dfe82a3f343f80d4b36074e3664f548aabe004711503eb1001"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7eee3bc0a0f69376fba772270747fc5ccc1e66b19c44e5988b9de33a3288df1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f70ecd18b09f48d00a547ece7d9e9fe51ed2beeb0786514aa27e23998df5c2b5"
    sha256 cellar: :any_skip_relocation, ventura:        "30b14963e21fe7a945902a66b9ba32a3a0913625a137757983f1099725cc6ffe"
    sha256 cellar: :any_skip_relocation, monterey:       "42064c19c775b6c02e0fdb30a97546019caba1fa74e367e3a3f87d1b2bcbf343"
    sha256 cellar: :any_skip_relocation, big_sur:        "80d550c087ae7946ac24632236a24dbc8fccdf56a0116d61d47c00e0e29be7e3"
    sha256 cellar: :any_skip_relocation, catalina:       "3cced2268352f85dacb344b225f2ea6ecddb6ee64cc150b0c260da67a56c1cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffb41efa5fff762c8c78d3c2e2f73465ad54cab74c2ca119c8c5c7cbe3fde940"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system ENV.cc, "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                   "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
