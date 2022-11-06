class Ciphey < Formula
  include Language::Python::Virtualenv

  desc "Automatic decryption and decoding tool"
  homepage "https://github.com/Ciphey/Ciphey"
  url "https://files.pythonhosted.org/packages/a5/db/9e0411803c768cd7f5c6986c9da406ae7e4b6b6a1d8ad0dc191cff6dbdaf/ciphey-5.14.0.tar.gz"
  sha256 "302a90261e9acc9b56ea29c313192f0c6f6ce112d37f4f9d404915052e19bf09"
  license "MIT"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a7c547b2f72a57eadfec07abb1e39223216eda3759acc91a76f3813d2e0e5fd4"
    sha256 cellar: :any,                 arm64_monterey: "8549423a0b8f5dbae34104539e9ae4a02ee373153b1be5e51e6fb19b0e2f5d65"
    sha256 cellar: :any,                 arm64_big_sur:  "c274722247b6a42d5d841f6aa0ff1f849f4d4f47883a93c06728a6b4136fb07f"
    sha256 cellar: :any,                 monterey:       "e324b009c010fd48f6d1cc742bd99fcce19bc233501d46cc9b9e82bb09a317e4"
    sha256 cellar: :any,                 big_sur:        "72e540064c7254d0e035b5ea05160b845aff94bc2a68871381315c219fda76ca"
    sha256 cellar: :any,                 catalina:       "81c331bdaf8ff4a1a8e9cc0632a3efb293ec14ebd1c1f3d1fc46f1f7ab19a12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1911d9ca626a6fc6b0be8b4c65ef77a4904a018a650e434b857918e6d1baa60f"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "poetry" => :build
  depends_on "swig" => :build
  depends_on "libyaml"
  depends_on "python@3.10"
  depends_on "six"

  on_linux do
    depends_on "rust" => :build
  end

  fails_with gcc: "5"

  resource "cipheycore" do
    url "https://github.com/Ciphey/CipheyCore/archive/v0.3.2.tar.gz"
    sha256 "d05b4c15077b56121e96c1b934ae2d49f14004834a9b8fbc1bdc76782cd66253"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/6a/7f/90312f42efc2a5249f26e436be10f0c53c512b2f3a36af364cd021283660/astroid-2.6.2.tar.gz"
    sha256 "38b95085e9d92e2ca06cf8b35c12a74fa81da395a6f9e65803742e6509c05892"
  end

  resource "base58" do
    url "https://files.pythonhosted.org/packages/b5/c1/8e77d5389cf1ea2535049e5ffaeb241cce21bcc1c42624b3e8d0fb3bb607/base58-2.1.0.tar.gz"
    sha256 "171a547b4a3c61e1ae3807224a6f7aec75e364c4395e7562649d7335768001a2"
  end

  resource "base91" do
    url "https://files.pythonhosted.org/packages/5b/19/b0f1df635561be1bcd74c652a2e611ebf0a9d5f5f10be9d8421733e2cb04/base91-1.0.1.tar.gz"
    sha256 "5b284a2ba3c97be1eb9473f3af94a9bf141d61005d836e75e645d2798da58799"
  end

  resource "cipheydists" do
    url "https://files.pythonhosted.org/packages/59/bf/0a2069da3364362986095a37929677ec71f8827988408c8bf9d815f32d14/cipheydists-0.3.35.tar.gz"
    sha256 "3436fde3f57df732e1a65fb03a565a564dd9d0c8d130c2e94f8b852e6a199a88"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "flake8" do
    url "https://files.pythonhosted.org/packages/9e/47/15b267dfe7e03dca4c4c06e7eadbd55ef4dfd368b13a0bab36d708b14366/flake8-3.9.2.tar.gz"
    sha256 "07528381786f2a6237b061f6e96610a4167b226cb926e2aa2b6b1d78057c576b"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/b7/8b/7c2200599c22b4ef6f3688f93c4f44065926bc05cbd38c31247b1348f9a3/isort-5.9.1.tar.gz"
    sha256 "83510593e07e433b77bd5bff0f6f607dbafa06d1a89022616f02d8b699cfcd56"
  end

  resource "langdetect" do
    url "https://files.pythonhosted.org/packages/0e/72/a3add0e4eec4eb9e2569554f7c70f4a3c27712f40e3284d483e88094cc0e/langdetect-1.0.9.tar.gz"
    sha256 "cbc1fef89f8d062739774bd51eda3da3274006b3661d199c2655f6b3f6d605a0"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/bb/f5/646893a04dcf10d4acddb61c632fd53abb3e942e791317dcdd57f5800108/lazy-object-proxy-1.6.0.tar.gz"
    sha256 "489000d368377571c6f982fba6497f2aa13c6d1facc40660963da62f5c379726"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/6d/25/0d65383fc7b4f4ce9505d16773b2b2a9f0f465ef00ab337d66afff47594a/loguru-0.5.3.tar.gz"
    sha256 "b28e72ac7a98be3d28ad28570299a393dfcd32e5e3f6a353dec94675767b6319"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/e2/be/3ea39a8fd4ed3f9a25aae18a1bff2df7a610bca93c8ede7475e32d8b73a0/mock-4.0.3.tar.gz"
    sha256 "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc"
  end

  resource "name-that-hash" do
    url "https://files.pythonhosted.org/packages/32/58/1f4052bd4999c5aceb51c813cc8ef32838561c8fb18f90cf4b86df6bd818/name-that-hash-1.10.0.tar.gz"
    sha256 "aabe1a3e23f5f8ca1ef6522eb1adcd5c69b5fed3961371ed84a22fc86ee648a2"
  end

  resource "pybase62" do
    url "https://files.pythonhosted.org/packages/f6/24/d8c2de1d9befb05ceabdb7530cb6d2b782838429912a7e6783ed1f0ae305/pybase62-0.4.3.tar.gz"
    sha256 "0fbbe8474fc5fb020cc7f94dc88adfd12ef9bf38640c46612568ea07f046438c"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/02/b3/c832123f2699892c715fcdfebb1a8fdeffa11bb7b2350e46ecdd76b45a20/pycodestyle-2.7.0.tar.gz"
    sha256 "c389c1d06bf7904078ca03399a4816f974a1d590090fecea0c63ec26ebaf1cef"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/a8/0f/0dc480da9162749bf629dca76570972dd9cce5bedc60196a3c912875c87d/pyflakes-2.3.1.tar.gz"
    sha256 "f5bc8ecabc05bb9d291eb5203d6810b49040f6ff446a756326104746cc00c1db"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "pylint" do
    url "https://files.pythonhosted.org/packages/59/9a/3a021b3b7965c5070bfec5d54759f076a31bd537043e0dc9b0fb2b49bff6/pylint-2.9.3.tar.gz"
    sha256 "23a1dc8b30459d78e9ff25942c61bb936108ccbe29dd9e71c01dc8274961709a"
  end

  resource "pywhat" do
    url "https://files.pythonhosted.org/packages/32/18/94ed2965c98f2577826bf642bd496516738c3056c824687c1453c2e88944/pywhat-1.1.0.tar.gz"
    sha256 "445cfe9ac2ccffd8438d4d4197fc5ec0ebbfac1ec241a75cd2e65ea5ed68e615"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/2f/b7/b8b950458f88c6d74978a37ad1d1fb9885464372fcb3d4077c2d9186a5c3/rich-10.4.0.tar.gz"
    sha256 "6e8a3e2c61e6cf6193bfcffbb89865a0973af7779d3ead913fdbbbc33f457c2c"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  def python3
    "python3.10"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    xy = Language::Python.major_minor_version python3
    python_path = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    resource("cipheycore").stage do
      args = std_cmake_args + %W[
        -DCIPHEY_CORE_TEST=OFF
        -DCIPHEY_CORE_PYTHON=#{python_path}
      ]
      system "cmake", "-S", ".", "-B", "build", *args
      system "cmake", "--build", "build", "-t", "ciphey_core"
      system "cmake", "--build", "build", "-t", "ciphey_core_py", "--config", "Release"

      cd "build" do
        system "poetry", "build", "-f", "sdist", "--verbose"
        venv.pip_install Dir["dist/cipheycore-*.tar.gz"].first
      end
    end

    res = resources.map(&:name).to_set - ["cipheycore"]
    res.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-ciphey.pth").write pth_contents
  end

  test do
    input_string = "U0dWc2JHOGdabkp2YlNCSWIyMWxZbkpsZHc9PQ=="
    expected_text = "Hello from Homebrew"
    assert_equal shell_output("#{bin}/ciphey -g -t #{input_string}").chomp, expected_text

    system python3, "-c", "from ciphey import decrypt"
    system python3, "-c", "from ciphey.iface import Config"
  end
end
