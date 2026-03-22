class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/c9/19/98d11e877fb1c13d1f0d66cd584db57acc4da35312f7cd4625374a31ef01/pipgrip-0.13.0.tar.gz"
  sha256 "d1ccbd1147a658b1ff8ba77d4c9f4151f2deb0637be07a86cb0e74fb21da73b5"
  license "BSD-3-Clause"
  head "https://github.com/ddelange/pipgrip.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aed6724ce03888fa70a34aac483962d7314edbdf3bb2c6a992e967f2496dddbe"
  end

  depends_on "python@3.14"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/bc/a8/eb55fab589c56f9b6be2b3fd6997aa04bb6f3da93b01154ce6fc8e799db2/anytree-2.13.0.tar.gz"
    sha256 "c9d3aa6825fdd06af7ebb05b4ef291d2db63e62bb1f9b7d9b71354be9d362714"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/89/24/a2eb353a6edac9a0303977c4cb048134959dd2a51b48a269dfc9dde00c8a/wheel-0.46.3.tar.gz"
    sha256 "e3e79874b07d776c40bd6033f8ddf76a7dad46a7b8aa1b2787a83083519a1803"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"pipgrip", shell_parameter_format: :click)
  end

  test do
    assert_match "pip==25.0.1", shell_output("#{bin}/pipgrip --no-cache-dir pip==25.0.1")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip --no-cache-dir dxpy==0.394.0")
  end
end
