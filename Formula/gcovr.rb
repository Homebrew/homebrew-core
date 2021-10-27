class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/83/0d/d8409c79412baa30717e6d18942251bc18d8cf43447b153f92056be99053/gcovr-5.0.tar.gz"
  sha256 "1d80264cbaadff356b3dda71b8c62b3aa803e5b3eb6d526a24932cd6660a2576"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/gcovr/gcovr.git"

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
