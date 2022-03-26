class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/af/f8/56408cb11843fb4197529b856f2f753403294ec61926a034241c594a9122/gcovr-5.1.tar.gz"
  sha256 "7780844359bff0b96c04147dafff25e6e585e05585bd542369bbc377d69de121"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02cac4be3ce9887e5dd058e755ae3fe9698bb2088a26bf6a89a4e3552c6c9adb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b43ccf52aaf6e863ba53338b2d56858a8e90ad6be7d25c86514a6b3a4017953d"
    sha256 cellar: :any_skip_relocation, monterey:       "a6db7f46eb7f0cb8f406c57a064fea54a8f005e4876a01795a0a531947f7d64e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f87e83edc1123b001b38e8d019c0490bac8372127db4059dedfd60041c27d3cd"
    sha256 cellar: :any_skip_relocation, catalina:       "c93ac984925f0d92abe6eb310adff1e15c27f37899a82e8e27fe895047cdf44c"
    sha256 cellar: :any_skip_relocation, mojave:         "941189cf0994e347c2a36dd844ff56e67c5b43c63cab9425dc7402d032242de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f55932c730770f1fb2d881429ba2055bb99f9d4f8c2372bad129b91207b68d8b"
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
