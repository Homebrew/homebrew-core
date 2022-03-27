class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/af/f8/56408cb11843fb4197529b856f2f753403294ec61926a034241c594a9122/gcovr-5.1.tar.gz"
  sha256 "7780844359bff0b96c04147dafff25e6e585e05585bd542369bbc377d69de121"
  license "BSD-3-Clause"
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
    url "https://files.pythonhosted.org/packages/89/e3/b36266381ae7a1310a653bb85f4f3658c462a69634fa9b2fef76252a50ed/Jinja2-3.1.1.tar.gz"
    sha256 "640bed4bb501cbd17194b3cace1dc2126f5b619cf068a726b98192a0fde74ae9"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/3b/94/e2b1b3bad91d15526c7e38918795883cee18b93f6785ea8ecf13f8ffa01e/lxml-4.8.0.tar.gz"
    sha256 "f63f62fc60e6228a4ca9abae28228f35e1bd3ce675013d1dfb828688d50c6e23"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
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
