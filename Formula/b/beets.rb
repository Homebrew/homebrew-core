class Beets < Formula
  include Language::Python::Virtualenv

  desc "Music library manager and tagger"
  homepage "https://beets.io/"
  url "https://files.pythonhosted.org/packages/1c/40/056537114e0c6df4374371341301c74b8519b571f3e67ec64f5547479a16/beets-2.12.0.tar.gz"
  sha256 "c5e844c4785a8b2c53a791a2b7bcd5846b4d12b0e8209e8eabfee06cec57edf2"
  license "MIT"
  head "https://github.com/beetbox/beets.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "2746fcfde157662663e1370e566af7c5841a4e5de38e1f76d60ccdb7c3a5bee7"
    sha256 cellar: :any, arm64_sequoia: "684ce8364bee9670ffb584cadfd0f8fcf9625ce1cd4500e80eee8e765b1f04a3"
    sha256 cellar: :any, arm64_sonoma:  "8f31a581742f1f6eb802e2dc1c69332bbab525af5d137e81c62c30813895c57f"
    sha256 cellar: :any, sonoma:        "f600fe1e1d0692efa2e2908643ee7753eb1fa1e9a06ceac6cf2851eee8497f04"
    sha256 cellar: :any, arm64_linux:   "1997779c62213180e6f261a4eaaf133fea7e895e42d41562f3cb43073c2da430"
    sha256 cellar: :any, x86_64_linux:  "c8cd98d29f6374b978ad10813e40a2585e6ad2ed60d5ade0a3fc5ac3406e36ab"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build # for jellyfish
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "llvm"
  depends_on "numpy"
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
    url "https://files.pythonhosted.org/packages/dc/a0/acc8ffcd5bdc63df0097e22c719bfcd61b604358343089313a8aebbb24ab/llvmlite-0.48.0.tar.gz"
    sha256 "543b19f9ef8f3c7c60d1468191e4ee1b1537bf9f8a3d56f64c0ddd98de92edd2"
  end

  resource "mediafile" do
    url "https://files.pythonhosted.org/packages/e3/02/460b31c20833036d8f171b991ff2f46c7f1dc85c6219e8bf7efca4a9aa5a/mediafile-0.17.0.tar.gz"
    sha256 "80c9003fd25d7096a7237e3b58e6ff018ef67f9c39900feafacabac1742c7d3a"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/df/70/1675da133ea92227da41bf5b24e1c66be597ff736a1533ade41da986852f/mutagen-1.48.1.tar.gz"
    sha256 "8f95637ab9f6f305cec6bd1294e197debe207998e3e068596563c74f86b0a173"
  end

  resource "numba" do
    url "https://files.pythonhosted.org/packages/ae/a0/570e3dc53e5602b49108f62a13e529f1eec8bfc7ef37d49c825924dcf546/numba-0.66.0.tar.gz"
    sha256 "b900e63a0e26c05ea9a6d5a3a5a0a177cb64c5011887bf43edb8c3ed2c38d363"
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
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
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
    python3 = "python3.14"
    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python3)

    without = %w[lap numba]
    venv = virtualenv_install_with_resources(without:)

    # Install these without build isolation to avoid building another `numpy`
    without.each { |r| venv.pip_install resource(r), build_isolation: false }
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

    system bin/"beet", "import", "-A", "-q", test_fixtures("test.mp3")
    assert_match "Tracks: 1", shell_output("#{bin}/beet stats")
  end
end
