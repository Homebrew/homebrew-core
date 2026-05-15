class Backgroundremover < Formula
  include Language::Python::Virtualenv

  desc "Remove background from images and video using AI"
  homepage "https://github.com/nadermx/backgroundremover"
  url "https://files.pythonhosted.org/packages/f5/8d/ebc742ef2c427bfec9047096b28ed380d390a566bf294fe0772a2b044940/backgroundremover-0.4.1.tar.gz"
  sha256 "3afa098d4538f44fd0bb44f9b77b63c29716fe7860dc79a3d51053d8cba2f753"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "baabb43835d21dd7d0768649cdace14ec7f2818b4a12787e19c475b4e6e00ef9"
    sha256 cellar: :any,                 arm64_sequoia: "45a9af94d76cae8af675f399c925f513851641ab04702beecac2512edadaba41"
    sha256 cellar: :any,                 arm64_sonoma:  "30ba7552a1da03903d24717b3939dd33dbac9a79f6b0a3331284fc26cb13784c"
    sha256 cellar: :any,                 sonoma:        "9f0deb9ce77b6fea6256c3f4fa2ee8d3d150b878831cbc67bef92ff5d1e0f7ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b5bcf773e696a4b5a08499e917c7e1934869444160181875dd2b36567560fd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6dfb1772f35284bf8f4a0a7d5583db4d68d3b756b06a02a39c2c493df54e4f"
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
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
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
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
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
    url "https://files.pythonhosted.org/packages/05/b1/efac073e0c297ecf2fb33c346989a529d4e19164f1759102dee5953ee17e/idna-3.14.tar.gz"
    sha256 "466d810d7a2cc1022bea9b037c39728d51ae7dad40d480fc9b7d7ecf98ba8ee3"
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/b1/84/93bcd1300216ea50811cee96873b84a1bebf8d0489ffaf7f2a3756bab866/imageio-2.37.3.tar.gz"
    sha256 "bbb37efbfc4c400fcd534b367b91fcd66d5da639aaa138034431a1c5e0a41451"
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
    url "https://files.pythonhosted.org/packages/01/88/a8952b6d5c21e74cbf158515b779666f692846502623e9e3c39d8e8ba25f/llvmlite-0.47.0.tar.gz"
    sha256 "62031ce968ec74e95092184d4b0e857e444f8fdff0b8f9213707699570c33ccc"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a2/f7/139d22fef48ac78127d18e01d80cf1be40236ae489769d17f35c3d425293/more_itertools-11.0.2.tar.gz"
    sha256 "392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804"
  end

  resource "moviepy" do
    url "https://files.pythonhosted.org/packages/de/61/15f9476e270f64c78a834e7459ca045d669f869cec24eed26807b8cd479d/moviepy-2.2.1.tar.gz"
    sha256 "c80cb56815ece94e5e3e2d361aa40070eeb30a09d23a24c4e684d03e16deacb1"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/f6/c5/db2ac3685833d626c0dcae6bd2330cd68433e1fd248d15f70998160d3ad7/numba-0.65.1.tar.gz"
    sha256 "19357146c32fe9ed25059ab915e8465fb13951cf6b0aace3826b76886373ab23"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/d7/9f/b8cef5bffa569759033adda9481211426f12f53299629b410340795c2514/numpy-2.4.4.tar.gz"
    sha256 "2d390634c5182175533585cc89f3608a4682ccb173cc9bb940b2881c8d6f8fa0"
  end

  resource "pillow-heif" do
    url "https://files.pythonhosted.org/packages/cd/58/2df4fc42840633e01c97b75965cb1bc6e14425973b92382391650e97e4b7/pillow_heif-1.3.0.tar.gz"
    sha256 "af8d2bda85e395677d5bb50d7bda3b5655c946cc95b913b5e7222fabacbb467f"
  end

  resource "proglog" do
    url "https://files.pythonhosted.org/packages/c2/af/c108866c452eda1132f3d6b3cb6be2ae8430c97e9309f38ca9dbd430af37/proglog-0.1.12.tar.gz"
    sha256 "361ee074721c277b89b75c061336cb8c5f287c92b043efa562ccf7866cda931c"
  end

  resource "pymatting" do
    url "https://files.pythonhosted.org/packages/9a/f5/83955aa915ea5e04cecb32612d419e8341604d0b898c2ebe4277adbc4c6b/pymatting-1.1.15.tar.gz"
    sha256 "67cbadd68d04696357461ad1861bcb3c2adc9ec5fcd38d524db606addabe745a"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "waitress" do
    url "https://files.pythonhosted.org/packages/bf/cb/04ddb054f45faa306a230769e868c28b8065ea196891f09004ebace5b184/waitress-3.0.2.tar.gz"
    sha256 "682aaaf2af0c44ada4abfb70ded36393f0e307f4ab9456a215ce0020baefc31f"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
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
