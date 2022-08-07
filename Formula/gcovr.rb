class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://files.pythonhosted.org/packages/ff/e6/7fdb0c3f73d630fcc94b0d4798d27fe22f6c72237b33ae887951791beacb/gcovr-5.2.tar.gz"
  sha256 "217195085ec94346291a87b7b1e6d9cfdeeee562b3e0f9a32b25c9530b3bce8f"
  license "BSD-3-Clause"
  head "https://github.com/gcovr/gcovr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ccc5a4c686da2482677c5424b796a05f5cdf100d11cba23bcb2d44ab151e01a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c39d6703dfdc2c802ec91b22b8ee21c52bba80d59f0c1c83a41926c039af2f7f"
    sha256 cellar: :any_skip_relocation, monterey:       "fedaf0456dc1ed174214ced2037eb7d2f84e00ecab7744816486c708437dd6fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "632d7ac5e69248e41a153c96b3ea64285a4974c0dc67c9e5c3f7d488ed9d0d52"
    sha256 cellar: :any_skip_relocation, catalina:       "deed239ab7c982d76f4591cbf35b7d95bf262bda29458e06e779991efd518faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f23a195eeea6262e493cf5597f36e95771ef6d9de50584a8b23f22d3350fdadf"
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
