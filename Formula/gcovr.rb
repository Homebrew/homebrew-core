class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/ff/e6/7fdb0c3f73d630fcc94b0d4798d27fe22f6c72237b33ae887951791beacb/gcovr-5.2.tar.gz"
  sha256 "217195085ec94346291a87b7b1e6d9cfdeeee562b3e0f9a32b25c9530b3bce8f"
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

  depends_on "python@3.11"

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
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
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
