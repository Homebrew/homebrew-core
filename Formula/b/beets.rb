class Beets < Formula
  include Language::Python::Virtualenv

  desc "Music library manager and tagger"
  homepage "https://beets.io/"
  url "https://files.pythonhosted.org/packages/1c/40/056537114e0c6df4374371341301c74b8519b571f3e67ec64f5547479a16/beets-2.12.0.tar.gz"
  sha256 "c5e844c4785a8b2c53a791a2b7bcd5846b4d12b0e8209e8eabfee06cec57edf2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b97ac8e7a750b703ca7a1c31fab76e02074a9e15e7a9bdf4755a7fda1f562b11"
    sha256 cellar: :any, arm64_sequoia: "da6a023b8a21ccda554715d460e0bdd807410571f56d7f61559cad8fb8ffd990"
    sha256 cellar: :any, arm64_sonoma:  "b0e8f1cba6a92e99a9793e3338abc7ba3441089daed267494e5defbc6519a6c0"
    sha256 cellar: :any, sonoma:        "cf0713c87e8d71f68d5ceaa7122c52fd726425f1b1951e051ecdca9f126345d2"
    sha256 cellar: :any, arm64_linux:   "bc44362cdf1ec2a06f4ef420add528718d560c24a894e19f4b5cf563d7c8d75e"
    sha256 cellar: :any, x86_64_linux:  "8790000e3600ebeccf1aae06ca041af393862426f76262e67fbaaf67073bb67a"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build # for jellyfish
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "llvm@20"
  depends_on "numpy"
  depends_on "python-packaging"
  depends_on "python@3.14"
  depends_on "scipy"
  depends_on "zstd"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: %w[certifi numpy scipy]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "confuse" do
    url "https://files.pythonhosted.org/packages/a2/a6/444c7376439851ce1d07932f88b707910d4605466d1c313621943c738112/confuse-2.2.0.tar.gz"
    sha256 "35c1b53e81be125f441bee535130559c935917b26aeaa61289010cd1f55c2b9e"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jellyfish" do
    url "https://files.pythonhosted.org/packages/0b/14/fc5bdb637996df181e5c4fa3b15dcc27d33215e6c41753564ae453bdb40f/jellyfish-1.2.1.tar.gz"
    sha256 "72d2fda61b23babe862018729be73c8b0dc12e3e6601f36f6e65d905e249f4db"
  end

  resource "lap" do
    url "https://files.pythonhosted.org/packages/f1/ae/5cc637c2e5158b7dcf1a9744d33b11dfc21d9309931169402f573e4d1ee3/lap-0.5.13.tar.gz"
    sha256 "9eff7169e3ca452995af0493cc20d35452c4bfd06122c36c06457119ffbd411b"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/01/88/a8952b6d5c21e74cbf158515b779666f692846502623e9e3c39d8e8ba25f/llvmlite-0.47.0.tar.gz"
    sha256 "62031ce968ec74e95092184d4b0e857e444f8fdff0b8f9213707699570c33ccc"
  end

  resource "mediafile" do
    url "https://files.pythonhosted.org/packages/e3/02/460b31c20833036d8f171b991ff2f46c7f1dc85c6219e8bf7efca4a9aa5a/mediafile-0.17.0.tar.gz"
    sha256 "80c9003fd25d7096a7237e3b58e6ff018ef67f9c39900feafacabac1742c7d3a"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/eb/2e/3e1b17cc655e59faac1008cfdaae2e38f123b9b229f0d1695f9860500d4d/mutagen-1.48.0.tar.gz"
    sha256 "4933d14b83a2add03c23e04a3c397ffbe44f130403f1256881ee228869aee3bb"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/f6/c5/db2ac3685833d626c0dcae6bd2330cd68433e1fd248d15f70998160d3ad7/numba-0.65.1.tar.gz"
    sha256 "19357146c32fe9ed25059ab915e8465fb13951cf6b0aace3826b76886373ab23"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/19/27/e564f33ea085c63d5540f707b31aeb50a4992eac2da655dc02435a760a07/pyrate_limiter-4.4.0.tar.gz"
    sha256 "2c0c720c4fa16c5d8199e4821bf34507fb49c007a25b786cec6fb94ffd0844aa"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-ratelimiter" do
    url "https://files.pythonhosted.org/packages/3a/71/aecc6307695ddad2d11f474cd79d79b111ee90dd123d697b76eaa1cd73a1/requests_ratelimiter-0.10.0.tar.gz"
    sha256 "9c1a78d7646caa5ccf211a6c341abd16d329be2c8c35044a418aa9da7c0e7a33"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    ENV["LLVMLITE_SHARED"] = "1"
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?
    python = "python3.14"
    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python)
    ENV.append_path "PYTHONPATH", formula_opt_prefix("python-setuptools")/Language::Python.site_packages(python)

    without = %w[lap numba]
    venv = virtualenv_install_with_resources(without:)

    # Install `lap` without build isolation to use the numpy formula dependency.
    venv.pip_install(resource("lap"), build_isolation: false)
    # We install `numba` separately without build isolation to avoid building another `numpy`
    venv.pip_install(resource("numba"), build_isolation: false)
  end

  test do
    (testpath/"config.yaml").write <<~YAML
      directory: #{testpath}/music
      library: #{testpath}/library.db
      import:
        copy: no
        move: no
        quiet: yes
    YAML

    ENV["BEETSDIR"] = testpath.to_s
    (testpath/"music").mkpath
    cp test_fixtures("test.mp3"), testpath/"music/test.mp3"

    system bin/"beet", "-c", testpath/"config.yaml", "import", "-A", "-q", testpath/"music/test.mp3"

    stats_output = shell_output("#{bin}/beet -c #{testpath}/config.yaml stats")
    assert_match "Tracks: 1", stats_output
  end
end
