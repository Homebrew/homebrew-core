class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/19/6d/2942ab8c693f2b9f97052d6a6de4c27323a3bd85af7d062dc5bd3a2a9604/gcovr-6.0.tar.gz"
  sha256 "8638d5f44def10e38e3166c8a33bef6643ec204687e0ac7d345ce41a98c5750b"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "468ca63ed2e3ddaf95aca7ac2a176318118f66dc44438bdee6e52729496666ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b735557fc7a0b6d0522a9a9e1ca1e5dee23aa317d8896209e3b754a7d587bf9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "607f232919e4021a863092b7c5a46dff07a28f4a6907e791a4ac6b7ee7b287e6"
    sha256 cellar: :any_skip_relocation, ventura:        "0a2a03ace1e658c3cd714a9384b6dbd636056ad0fbc4a7a7d4c40cd8a4158e23"
    sha256 cellar: :any_skip_relocation, monterey:       "701d209c21e70c0489b2f4398df7e2473ca0143bb28865fdc466ba33f69510db"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f2fef2957ccfa495cea4d68818bf365644e7d372701387441c01175b0f96384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0b4b37582a65a91590a1d609ad5a02a613738e92e9290d7d81e181c751201ee"
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
