class Backgroundremover < Formula
  include Language::Python::Virtualenv

  desc "Remove background from images and video using AI"
  homepage "https://github.com/nadermx/backgroundremover"
  url "https://files.pythonhosted.org/packages/b9/4a/18deace4c210d722e4dde75a7f445f105d96d190f767b9132d789b1503dd/backgroundremover-0.3.8.tar.gz"
  sha256 "0f6c25e500eab0268fdc3f50574e5f8aca1f5f47fcad86f4b52ea2af814a7434"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69e37dcd7efe1a106eb9ed92f75b1a44761e8991df4b9c19c66e7d795288a48e"
    sha256 cellar: :any,                 arm64_sequoia: "70a153a6e2a876ee70469504219063b6bdad259c9694be44c70f5bd244000ed7"
    sha256 cellar: :any,                 arm64_sonoma:  "fd6232c5c2d6e44a35f4aa23c601cd568072e3bddb614654165d3394460ef8b9"
    sha256 cellar: :any,                 sonoma:        "2aef3bc9f546365b02f1ea0b172da7ea8a4187a527fa311ea36a00485c4bed94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb04fd6b8986e4f01974dad5efe8806b0fa080d6f25b62b68515ffa1637e026b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3616674f766effd0d2d82a44c4367e971701d2f656ef31a9a2b4149dbc84967"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "libheif"
  depends_on "llvm@20"
  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "scikit-image"
  depends_on "scipy"
  depends_on "torchvision"

  on_linux do
    depends_on "patchelf" => :build
    depends_on "openblas"
  end

  # numba 0.63.1 does not support numpy 2.4.x, see https://github.com/numba/numba/issues/10263
  pypi_packages exclude_packages: %w[certifi torch torchvision pillow scipy scikit-image],
                extra_packages:   %w[imageio numpy]

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "commandlines" do
    url "https://files.pythonhosted.org/packages/b9/4c/d380f7f9aaa12175b189cfe087e823cd9aa2a99afc95a8d6e028142311c9/commandlines-0.4.1.tar.gz"
    sha256 "86b650b78470ac95966d7b1a9d215c16591bccb34b28ae2bb9026c3b4166fd64"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "ffmpeg-python" do
    url "https://files.pythonhosted.org/packages/dd/5e/d5f9105d59c1325759d838af4e973695081fbbc97182baf73afc78dec266/ffmpeg-python-0.2.0.tar.gz"
    sha256 "65225db34627c578ef0e11c8b1eb528bb35e024752f6f10b78c011f6f64c4127"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "hsh" do
    url "https://files.pythonhosted.org/packages/88/dd/c04f9a56e374e7fe5a0ac5032d0a059ef7338485bcd2ae1a05115081c4e1/hsh-1.1.0.tar.gz"
    sha256 "c04e43ac538feafb029dba3c4972207a704f5fcdf0ee271ebdddd03d96b5df85"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/a3/6f/606be632e37bf8d05b253e8626c2291d74c691ddc7bcdf7d6aaf33b32f6a/imageio-2.37.2.tar.gz"
    sha256 "0212ef2727ac9caa5ca4b2c75ae89454312f440a756fcfc8ef1993e718f50f8a"
  end

  resource "imageio-ffmpeg" do
    url "https://files.pythonhosted.org/packages/44/bd/c3343c721f2a1b0c9fc71c1aebf1966a3b7f08c2eea8ed5437a2865611d6/imageio_ffmpeg-0.6.0.tar.gz"
    sha256 "e2556bed8e005564a9f925bb7afa4002d82770d6b08825078b7697ab88ba1755"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/74/cd/08ae687ba099c7e3d21fe2ea536500563ef1943c5105bf6ab4ee3829f68e/llvmlite-0.46.0.tar.gz"
    sha256 "227c9fd6d09dce2783c18b754b7cd9d9b3b3515210c46acc2d3c5badd9870ceb"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "moviepy" do
    url "https://files.pythonhosted.org/packages/de/61/15f9476e270f64c78a834e7459ca045d669f869cec24eed26807b8cd479d/moviepy-2.2.1.tar.gz"
    sha256 "c80cb56815ece94e5e3e2d361aa40070eeb30a09d23a24c4e684d03e16deacb1"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/dc/60/0145d479b2209bd8fdae5f44201eceb8ce5a23e0ed54c71f57db24618665/numba-0.63.1.tar.gz"
    sha256 "b320aa675d0e3b17b40364935ea52a7b1c670c9037c39cf92c49502a75902f4b"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/76/65/21b3bc86aac7b8f2862db1e808f1ea22b028e30a225a34a5ede9bf8678f2/numpy-2.3.5.tar.gz"
    sha256 "784db1dcdab56bf0517743e746dfb0f885fc68d948aba86eeec2cba234bdf1c0"
  end

  resource "pillow-heif" do
    url "https://files.pythonhosted.org/packages/64/65/77284daf2a8a2849b9040889bd8e1b845e693ed97973a28ba2122b8922ad/pillow_heif-1.1.1.tar.gz"
    sha256 "f60e8c8a8928556104cec4fff39d43caa1da105625bdb53b11ce3c89d09b6bde"
  end

  resource "proglog" do
    url "https://files.pythonhosted.org/packages/c2/af/c108866c452eda1132f3d6b3cb6be2ae8430c97e9309f38ca9dbd430af37/proglog-0.1.12.tar.gz"
    sha256 "361ee074721c277b89b75c061336cb8c5f287c92b043efa562ccf7866cda931c"
  end

  resource "pymatting" do
    url "https://files.pythonhosted.org/packages/35/43/cd7a82913dfde95dfb653efd09c7b394a76b3865570050b674a36fc0078c/pymatting-1.1.14.tar.gz"
    sha256 "75e2ec1e346dbd564c9a2cc8229b134ec939f49008fa570025db30003d0c46fc"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f0/26/19cadc79a718c5edbec86fd4919a6b6d3f681039a2f6d66d14be94e75fb9/python_dotenv-1.2.1.tar.gz"
    sha256 "42667e897e16ab0d66954af0e60a9caa94f0fd4ecf3aaf6d2d260eec1aa36ad6"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "waitress" do
    url "https://files.pythonhosted.org/packages/bf/cb/04ddb054f45faa306a230769e868c28b8065ea196891f09004ebace5b184/waitress-3.0.2.tar.gz"
    sha256 "682aaaf2af0c44ada4abfb70ded36393f0e307f4ab9456a215ce0020baefc31f"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/5a/70/1469ef1d3542ae7c2c7b72bd5e3a4e6ee69d7978fa8a3af05a38eca5becf/werkzeug-3.1.5.tar.gz"
    sha256 "6a548b0e88955dd07ccb25539d7d0cc97417ee9e179677d22c7041c8f078ce67"
  end

  def install
    ENV["LLVMLITE_SHARED"] = "1"
    venv = virtualenv_install_with_resources

    # We depend on the formula below, but they are separate formula, so install a `.pth` file to link them.
    # NOTE: This is an exception to our usual policy as building them is complicated
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    torchvision_pth_contents = "import site; site.addsitedir('#{Formula["torchvision"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-torchvision.pth").write torchvision_pth_contents

    skimage_pth_contents = "import site; site.addsitedir('#{Formula["scikit-image"].opt_libexec/site_packages}')\n"
    (venv.site_packages/"homebrew-scikit-image.pth").write skimage_pth_contents
  end

  test do
    system bin/"backgroundremover", "-i", test_fixtures("test.jpg"), "-o", testpath/"output.png"
    assert_path_exists testpath/"output.png"
  end
end
