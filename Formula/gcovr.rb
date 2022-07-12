class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/af/f8/56408cb11843fb4197529b856f2f753403294ec61926a034241c594a9122/gcovr-5.1.tar.gz"
  sha256 "7780844359bff0b96c04147dafff25e6e585e05585bd542369bbc377d69de121"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e8adcfba821a1015ca5264d6b657168d0607361816c3b6125a4df45d9692392"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74ae8e3269cba62fd168a6ff8dfccf708ee967c19ae1368112af8154e1151389"
    sha256 cellar: :any_skip_relocation, monterey:       "f88c045db39ce682304ccf040906760d7981d07a6b5dce820c0aa618e9320c54"
    sha256 cellar: :any_skip_relocation, big_sur:        "e902129f8caf3f14edd1632428d0bb3a96057734f6ceacfb62b6692451b17a7a"
    sha256 cellar: :any_skip_relocation, catalina:       "45d4549efd00c40e1aeb64d5fd551530d49a2fea3a10b48c5b11e9f0ff3fa7d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "250ca2155f0eb9545d77fb6947cfac0df80d540947050438a523d9c30c86ba89"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
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
