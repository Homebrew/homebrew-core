class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://github.com/conda/grayskull"
  url "https://files.pythonhosted.org/packages/c7/20/c8557733b2b52ea1714c018a24b735e33cb69f9b44dbcef9cf4dd562f849/grayskull-2.9.2.tar.gz"
  sha256 "874890191b1999bfde97b09ac6d37dae4636aa87a9dd2ee1bf10e748ffba20ef"
  license "Apache-2.0"
  head "https://github.com/conda/grayskull.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd56ad1475836eb1fe2018bfb1c290ec8fb48c099de31d3ba5cb8546c25abc5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b74fbc3b6764a32ca8196e5728a94ed9ffade8fc39c1ccd6f2c6ca9b17cf71e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebcf7b8e686ea80a0f325e9d90d7ddc1ec6849278dddf8eadb957dfbd6f72214"
    sha256 cellar: :any_skip_relocation, sonoma:        "42a8dd29819f80e322a24158d94cb6aa0a20278028e7db7194a5f6ea7b8158fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8745474556631f99abce5353a96c46692ec7fe9231df66e543aae3beb8f50703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b807d7bf4c5a6f7c0a9385b584d687137ef5837341de5597125570ad54c02ba"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "conda-souschef" do
    url "https://files.pythonhosted.org/packages/78/6a/c4d067f8ef39b058a9bd03018093e97f69b7b447b4e1c8bd45439a33155d/conda-souschef-2.2.3.tar.gz"
    sha256 "9bf3dba0676bc97616636b80ad4a75cd90582252d11c86ed9d3456afb939c0c3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
    url "https://files.pythonhosted.org/packages/13/4c/ef8b7b1046d65c1f18ca31e5235c7d6627ca2b3f389ab1d44a74d22f5cc9/python_utils-3.9.1.tar.gz"
    sha256 "eb574b4292415eb230f094cbf50ab5ef36e3579b8f09e9f2ba74af70891449a0"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/d3/28/9d808fe62375b9aab5ba92fa9b29371297b067c2790b2d7cda648b1e2f8d/rapidfuzz-3.14.3.tar.gz"
    sha256 "2491937177868bc4b1e469087601d53f925e8d270ccc21e07404b4b5814b7b5f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/9f/c7/ee630b29e04a672ecfc9b63227c87fd7a37eb67c1bf30fe95376437f897c/ruamel.yaml-0.18.16.tar.gz"
    sha256 "a6e587512f3c998b2225d68aa1f35111c29fad14aed561a26e73fab729ec5e5a"
  end

  resource "ruamel-yaml-jinja2" do
    url "https://files.pythonhosted.org/packages/91/e0/ad199ab894f773551fc352541ce3305b9e7c366a4ae8c44ab1bc9ca3abff/ruamel.yaml.jinja2-0.2.7.tar.gz"
    sha256 "8449be29d9a157fa92d1648adc161d718e469f0d38a6b21e0eabb76fd5b3e663"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
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
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
