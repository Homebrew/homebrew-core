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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83662d5efc0b3cb13143c7a86e06d30f7485e51b59494b75bae2b3ea85a137d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2481413a3ebecdf9cbd5b1cf9985c881ea256f7d0130c1edec5a1c118b9d382a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cd48c8122cb0537d4088eb2ca4e91f46ef65edfe3c63a61d8414dc00be360e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "273a1e1512ab90201d3f49807acecd652d552b052b988553ec31785e21001cc9"
    sha256 cellar: :any_skip_relocation, ventura:        "d1b37b94e8cb476dda3bdb5fc7ccca18dd0f62d0b7fbb48dfe5d523167f3f381"
    sha256 cellar: :any_skip_relocation, monterey:       "e663267a10af1c56a6b287ddb8ad32b98ad168772b5e67f04bbf172b9ec242d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aacf6be867f4a74b5d1a565dfb81f73c4625d573c388467f8356f4e9e02e17e"
  end

  depends_on "pygments"
  depends_on "python-lxml"
  depends_on "python@3.11"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
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
