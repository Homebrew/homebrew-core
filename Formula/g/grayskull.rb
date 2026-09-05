class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://conda.github.io/grayskull/"
  url "https://files.pythonhosted.org/packages/89/45/abdddfb30303923b3abb01f21d2da114d582f2df299b71124687dac9b7c7/grayskull-3.2.0.tar.gz"
  sha256 "467bb43a7de610fc8719e520c9e9049f597a28d9e72c0ff047127b5340569ddb"
  license "Apache-2.0"
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
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
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
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/3e/ad/97538d5a1041d8d3ba155075b0b35248cf8538e1f1ec764f1d117962b01d/pkginfo-1.13.tar.gz"
    sha256 "4f70471c643f71fe84a06230c0e33c5c5b12a33b2fd21bff14ddaef5a974adb1"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/0c/1e/5bd376abe32a392e74fffd82feb42ee1472d263bd358d628af20663d0346/progressbar2-4.6.0.tar.gz"
    sha256 "fe48c8955a84428af77bff2642ba47041e1b8f7c867a5b7cc94f8bc255a8f0cf"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/5d/71/ec6665d4ce42ee5a59fffd31a4d5164f92da15ccb8c758dba13d2419ea53/python_utils-4.0.1.tar.gz"
    sha256 "4e8e8ecaba3862f843a60c1982c99cda23b522f417006a807996a876c18beb8d"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/18/97/226c43b7b5d957bc3840ed52ea99eed261f99834c4619be7a4742cbaeafa/rapidfuzz-3.14.6.tar.gz"
    sha256 "e13a8160d017b499ec7a2fa9d0ce1ae2e7377080815785819f966fb235d4eb60"
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
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/69/99/a6ca3beb3ccacb41fb3321d8a60e5566f9e6467601ef8eba6a17e1b89778/soupsieve-2.9.2.tar.gz"
    sha256 "4a55d8cf158a9c2e587fa4922f1bbb91d68ac829e2d6f25403a85747c71daf74"
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
