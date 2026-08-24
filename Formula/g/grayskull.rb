class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://conda.github.io/grayskull/"
  url "https://files.pythonhosted.org/packages/7a/51/b7d181b55fd65f4ba0c0414b5f779f342f8296f991a52af2de2399b501bf/grayskull-3.1.1.tar.gz"
  sha256 "46ea09c3322f200c35c807dc34dfaf0fc203352fc39d6c222e31a5b065f2f690"
  license "Apache-2.0"
  revision 3
  head "https://github.com/conda/grayskull.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b79be86c0edace663a29899cd5071d9b9ffb1ba14db4eb9d5b6d8b2ca268eff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3375139e38408669370f04bed03ffae8d51ab44d12046bc2be38a7d49a277562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd917273b927af26e24ce7d59fe91a91ad9bf9bf87fbae09f60ed994735ae74b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b01630de5046f1776aed467a637d4ba34fe643beb9fa5761f7168ce933297adc"
    sha256 cellar: :any,                 arm64_linux:   "5118db60a2a4cf06ffba35a1ca62157d00a5bb1b376abf7b33e67137afcb670d"
    sha256 cellar: :any,                 x86_64_linux:  "cd6f0c5af793ae17d37f3c6d553789dfe85402e3da6ad78500ffa478eef1b3e5"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build # for python-utils
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "conda-souschef" do
    url "https://files.pythonhosted.org/packages/5b/bb/1d24463afd34bd572d4da1cae26a353925c8102241944d47c75b23321eb8/conda_souschef-3.0.1.tar.gz"
    sha256 "0df9fa12d826ab349e8006e498c6067b3a5161cf5b860baf08601829cb1b200b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/24/03/e26bf3d6453b7fda5bd2b84029a426553bb373d6277ef6b5ac8863421f87/pkginfo-1.12.1.2.tar.gz"
    sha256 "5cd957824ac36f140260964eba3c6be6442a8359b8c48f4adf90210f33a04b7b"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/19/24/3587e795fc590611434e4bcb9fbe0c3dddb5754ce1a20edfd86c587c0004/progressbar2-4.5.0.tar.gz"
    sha256 "6662cb624886ed31eb94daf61e27583b5144ebc7383a17bae076f8f4f59088fb"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/2e/4f/ffd054f649cb9deca624a61d83fd17ce5b6247ba6c41a5881b0c639573d7/python_utils-4.0.0.tar.gz"
    sha256 "51d84b297d9877205a76e65f970e3275d1aa9c1cf3d508af2c459247eb4fe701"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/2c/21/ef6157213316e85790041254259907eb722e00b03480256c0545d98acd33/rapidfuzz-3.14.5.tar.gz"
    sha256 "ba10ac57884ce82112f7ed910b67e7fb6072d8ef2c06e30dc63c0f604a112e0e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "ruamel-yaml-jinja2" do
    url "https://files.pythonhosted.org/packages/91/e0/ad199ab894f773551fc352541ce3305b9e7c366a4ae8c44ab1bc9ca3abff/ruamel.yaml.jinja2-0.2.7.tar.gz"
    sha256 "8449be29d9a157fa92d1648adc161d718e469f0d38a6b21e0eabb76fd5b3e663"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/2c/0a5f6f8ee0d5589e48c7640213ed5175d52cf540a06725b628cc1a45d6ce/soupsieve-2.8.4.tar.gz"
    sha256 "e121fd02e975c695e4e9e8774a5ee35d74714b59307868dcc5319ad2d9e3328e"
  end

  resource "stdlib-list" do
    url "https://files.pythonhosted.org/packages/8c/25/f1540879c8815387980e56f973e54605bd924612399ace31487f7444171c/stdlib_list-0.12.0.tar.gz"
    sha256 "517824f27ee89e591d8ae7c1dd9ff34f672eae50ee886ea31bb8816d77535675"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    venv = virtualenv_install_with_resources without: "ruamel-yaml-jinja2"

    # Fix `ast` aliases removed in 3.14
    # Upstream has not been updated since 2021: https://sourceforge.net/projects/ruamel-yaml-jinja2/
    resource("ruamel-yaml-jinja2").stage do
      inreplace "setup.py" do |s|
        s.gsub!(/node\.(n|s)\b/, "node.value")
        s.gsub! "from ast import Str, Num, Bytes, NameConstant",
                "from ast import Constant; Str = Num = Bytes = NameConstant = Constant"
      end
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_equal version, shell_output("#{bin}/grayskull --version").strip

    system bin/"grayskull", "pypi", "grayskull"
    assert_path_exists testpath/"grayskull/meta.yaml"
  end
end
