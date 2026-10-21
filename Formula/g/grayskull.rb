class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://conda.github.io/grayskull/"
  url "https://files.pythonhosted.org/packages/89/45/abdddfb30303923b3abb01f21d2da114d582f2df299b71124687dac9b7c7/grayskull-3.2.0.tar.gz"
  sha256 "467bb43a7de610fc8719e520c9e9049f597a28d9e72c0ff047127b5340569ddb"
  license "Apache-2.0"
  revision 1
  head "https://github.com/conda/grayskull.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60611eb6040b5c18a5569f54343e565c18b80d56ce51eec2477ae23c023719f2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "634fc70613a1fcf8758eb6a576bc3d495e6d399233e4ec33b859efc7ad445359"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "614deb14d92abcd3dfb7073db9f59373d7e5d83682e9e9661869cd5ad8c46d34"
    sha256 cellar: :any,                 arm64_linux:       "d02e29e4d739776a254768d8be0e27a4496173439aa9219fe7a9894c40c73b62"
    sha256 cellar: :any,                 x86_64_linux:      "3a3398d4f09f73ca60878e68479fcb4b436d0951194f73977da6e5ea72ff0b7d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build # for python-utils
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
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
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
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
    url "https://files.pythonhosted.org/packages/8f/dd/fdc08309ce1122e77e5ebc3908aa6f4e2dfed3e08f6987ae650c2591ee0c/python_utils-4.1.0.tar.gz"
    sha256 "218518ac7ba34a7d8ea66d19274e5246cd5de122efeedcf2e5b6c00965b969b7"
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
    url "https://files.pythonhosted.org/packages/71/c3/1b817965ac12dc002d7c9cd7dfffdd7d4fbf9b45763ef2ffe7b86ee94670/soupsieve-2.10.tar.gz"
    sha256 "49e9380d7d2905463583bafe285e818c7366a9ed7b3aee221c1ac79c905d8bc0"
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
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  deny_network_access! :test

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

    (testpath/"homebrew-test-1.0.0/setup.py").write <<~PYTHON
      from setuptools import setup
      setup(name="homebrew-test", version="1.0.0", py_modules=["homebrew_test"], license="MIT")
    PYTHON
    (testpath/"homebrew-test-1.0.0/homebrew_test.py").write "VALUE = 42\n"
    system "tar", "-czf", "homebrew-test-1.0.0.tar.gz", "homebrew-test-1.0.0"

    system bin/"grayskull", "pypi", "homebrew-test-1.0.0.tar.gz", "--no-use-v1-format"
    assert_match "name: homebrew-test", (testpath/"homebrew-test/meta.yaml").read
  end
end
