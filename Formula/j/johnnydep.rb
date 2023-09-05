class Johnnydep < Formula
  include Language::Python::Virtualenv

  desc "Display dependency tree of Python distribution"
  homepage "https://github.com/wimglenn/johnnydep"
  url "https://files.pythonhosted.org/packages/ac/4f/a6e38abe80edd42b366fc3420542e548ac1039f514126db605ee5a09c4c9/johnnydep-1.20.3.tar.gz"
  sha256 "0f26a9e50e8f4d20eb7abbd2bd85fe352a6f28b5630999ee470c0d0c76c10911"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de94e94726133216f77b8a14904fea72e6249d11056e1575f2b0642fdf283bc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f9d87f8eea995073cbcea25c564432816c8f4ab284f4698c6cfc1ce981f295a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27fd5b5ed3a42591ec58d2078d2f51f8988b949935be528894ac70f1ee616900"
    sha256 cellar: :any_skip_relocation, ventura:        "bb6e2bd87eef32400a569e7950f13c334fba8f2d0d908a47ae4a5201598ba6a4"
    sha256 cellar: :any_skip_relocation, monterey:       "5bcef486cf0c202df58094484a27de695e73cd1590e215fc3abaed43e80169d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a53d592ae95a9dffe5184212f583253e291e1db4c516841d003484b4e87cda12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb95e640ed28b4059c5a6a7941ef97cc7932ba91d7cc09bdb2e1e71abf058b79"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/ed/20/560b2c0801762f3de73ce04dd20d50ec39c2cdae83f23b6ed81cc72c7558/anytree-2.9.0.tar.gz"
    sha256 "06f7bc294293da2755f4699cc5da5c92d9182a5cfae2842c83fb56f02bd427c8"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "oyaml" do
    url "https://files.pythonhosted.org/packages/00/71/c721b9a524f6fe6f73469c90ec44784f0b2b1b23c438da7cc7daac1ede76/oyaml-1.0.tar.gz"
    sha256 "ed8fc096811f4763e1907dce29c35895d6d5936c4d0400fe843a91133d4744ed"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/9e/c4/688d14600f3a8afa31816ac95220f2548648e292c3ff2262057aa51ac2fb/structlog-23.1.0.tar.gz"
    sha256 "270d681dd7d163c11ba500bc914b2472d2b50a8ef00faa999ded5ff83a2f906b"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c9/3d/02a14af2b413d7abf856083f327744d286f4468365cddace393a43d9d540/wheel-0.41.1.tar.gz"
    sha256 "12b911f083e876e10c595779709f8a88a59f45aacc646492a67fe9ef796c1b47"
  end

  resource "wimpy" do
    url "https://files.pythonhosted.org/packages/6e/bc/88b1b2abdd0086354a54fb0e9d2839dd1054b740a3381eb2517f1e0ace81/wimpy-0.6.tar.gz"
    sha256 "5d82b60648861e81cab0a1868ae6396f678d7eeb077efbd7c91524de340844b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/johnnydep johnnydep")
    resources.each do |r|
      assert_match r.name, output
    end
  end
end
