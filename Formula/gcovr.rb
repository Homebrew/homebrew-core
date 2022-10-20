class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/ff/e6/7fdb0c3f73d630fcc94b0d4798d27fe22f6c72237b33ae887951791beacb/gcovr-5.2.tar.gz"
  sha256 "217195085ec94346291a87b7b1e6d9cfdeeee562b3e0f9a32b25c9530b3bce8f"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8fed94a127327339a1a5c571f687ef169bc1d2df359a1f20e4c74e253645c02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36969e4f3cb4fc868d2a3c168c5ff1564154e7173be06f9920dbe5dfdfd5d6e6"
    sha256 cellar: :any_skip_relocation, monterey:       "5b13a3cb220e0c835577a46d06a5ca3b000378a9bd7bf42d86d76a530348588e"
    sha256 cellar: :any_skip_relocation, big_sur:        "21933ce627f701a515c6f0f11e4797e70a8d4694f90ebcae1809b701c123ead7"
    sha256 cellar: :any_skip_relocation, catalina:       "0f5febc5b78f08f3011bba00412ea6f2c27a9a67bb0c0fe0c99bccf4c087f17a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f50db5ded09aad3ec882ce2eb406b543bc37387c52a09fb431d3c035b1c4e444"
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
