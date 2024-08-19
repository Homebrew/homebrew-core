class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/ed/9b/119d9b9501a9d0bc91be6b163be98125a9345e37871f4f3243b112d456e6/gcovr-7.2.tar.gz"
  sha256 "e3e95cb56ca88dbbe741cb5d69aa2be494eb2fc2a09ee4f651644a670ee5aeb3"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "541dda093740c839214b67caea3bc64410a7c122c93da33157a1222f58d101c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea5b4d5d3c4199cd88130e841a280f2449056a5091f55debf5aa40f6d3cf054d"
    sha256 cellar: :any,                 arm64_monterey: "e77832fc4dcfbed22854b767c52288b9c46b316c28eb60e717926a5a4409a803"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd4c83f368adaef8795ae06e3245c9af0c53a4d879b586bed925b4b32502d300"
    sha256 cellar: :any_skip_relocation, ventura:        "c567434a6dac1c772c8d0e72f20a17b75ffd97d9f12a37c4adebf13e074ed2a8"
    sha256 cellar: :any,                 monterey:       "8bcc1c8d1c3690fe89dcf1254b24a333379c8154d9258f090be82400c9adb8c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1415bb632e06c9b24f627b769ffd982c6cb766daa1f3f60b6d5ae305ff57f81"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/db/38/2992ff192eaa7dd5a793f8b6570d6bbe887c4fbbf7e72702eb0a693a01c8/colorlog-6.8.2.tar.gz"
    sha256 "3e3e079a41feb5a1b64f978b5ea4f46040a94f11f0e8bbb8261e3dbbeca64d44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ea/e2/3834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3/lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
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
