class Doitlive < Formula
  include Language::Python::Virtualenv

  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/02/5a/ec8769dc1c6f81939c0f7839b885f27b62b79b67fe69fcc67f347c0dd3ff/doitlive-4.4.0.tar.gz"
  sha256 "1b0031d6ce97778a292b247ccb762fda8212c1b935bc7da6a2be92f677a4ea60"
  license "MIT"
  head "https://github.com/sloria/doitlive.git", branch: "dev"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f10112e06f74050aa8e16ffe0e3924b303c62887cc77eac2d5d7d32f33b58cb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5945959c51c80bd63648e790362c6cfe893e9e7bc852dffd8b303ec45b6afb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aabc3ff198b25ecb5b60c58214842259a505e16d42ecf6c7845faf2ff264bbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "4897a6438252d48c21819d032731027ecef4d1bcd88f3d33bde6a84a32db6859"
    sha256 cellar: :any_skip_relocation, ventura:        "62b2fd9fbcb61ad896e6ade4f7a0cf535dc39f6b72ed163795f1bc4e8395d036"
    sha256 cellar: :any_skip_relocation, monterey:       "067de77d8dc04c38a43571e9d16fe0cc8ae3524824d9af688193137f6fcbce1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69814d9e75a202174bb17915b2e32bbcffe73fa09f3e6f3574b97a64154af3f9"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "click-completion" do
    url "https://files.pythonhosted.org/packages/93/18/74e2542defdda23b021b12b835b7abbd0fc55896aa8d77af280ad65aa406/click-completion-0.5.2.tar.gz"
    sha256 "5bf816b81367e638a190b6e91b50779007d14301b3f9f3145d68e3cade7bce86"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/2f/a7/822fbc659be70dcb75a91fb91fec718b653326697d0e9907f4f90114b34f/click-didyoumean-0.3.0.tar.gz"
    sha256 "f184f0d851d96b6d29297354ed981b7dd71df7ff500d82fa6d11f0856bee8035"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/74/31/6d2297b76389dd1b542962063675eb19bb9225421f278d9241da0c672739/shellingham-1.5.3.tar.gz"
    sha256 "cb4a6fec583535bc6da17b647dd2330cf7ef30239e05d547d99ae3705fd0f7f8"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"doitlive", "completion", shell_parameter_format: :none)
  end

  test do
    system bin/"doitlive", "themes", "--preview"
  end
end
