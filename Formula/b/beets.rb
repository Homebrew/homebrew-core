class Beets < Formula
  include Language::Python::Virtualenv

  desc "Music library manager and tagger"
  homepage "https://beets.io/"
  url "https://files.pythonhosted.org/packages/b0/5e/ad1f57f5de4846e7b274f2fa3b9df4dd7a641cb35bf047698a99b5179279/beets-2.14.1.tar.gz"
  sha256 "b25dc7bf8ed093d8b6e043e88013736902c1082c958b81a598af5db5275539a5"
  license "MIT"
  head "https://github.com/beetbox/beets.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c6855c76b0a980219852f6968e35ef09f0ede09cb4b56e7f6e9e3f8bf88610d4"
    sha256 cellar: :any, arm64_tahoe:       "29c0f8221048bc797ab30dead5a163c8728eb5094df2fdc08828aa6df812d352"
    sha256 cellar: :any, arm64_sequoia:     "fdc41fa296ed2ea8b62dfd4145e17b75b098b56008f7c7f8fa9f8a1d65b68e81"
    sha256 cellar: :any, arm64_linux:       "ef9adcf249ec403ae6c062a5fcb377559ab119574ce8db381eca93a732c96fab"
    sha256 cellar: :any, x86_64_linux:      "3ba6d305c69e1b232f4519cb84d9ca19f62b6d4cf782209e7ddf57e776d4522c"
  end

  depends_on "cython" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build # for jellyfish
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "numpy" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi numpy]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "confuse" do
    url "https://files.pythonhosted.org/packages/98/45/3ad821336a7953a2322e7e2d062488cfe179748725e5165117151b88a121/confuse-2.2.1.tar.gz"
    sha256 "8e7600c3261852122eb5f17b24b06ab8e5437b21d6224853c1420c38ac469d3c"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/bb/29/745f7d30d47fe0f251d3ad3dc2978a23141917661998763bebb6da007eb1/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jellyfish" do
    url "https://files.pythonhosted.org/packages/0b/14/fc5bdb637996df181e5c4fa3b15dcc27d33215e6c41753564ae453bdb40f/jellyfish-1.2.1.tar.gz"
    sha256 "72d2fda61b23babe862018729be73c8b0dc12e3e6601f36f6e65d905e249f4db"
  end

  resource "lap" do
    url "https://files.pythonhosted.org/packages/f1/ae/5cc637c2e5158b7dcf1a9744d33b11dfc21d9309931169402f573e4d1ee3/lap-0.5.13.tar.gz"
    sha256 "9eff7169e3ca452995af0493cc20d35452c4bfd06122c36c06457119ffbd411b"
  end

  resource "mediafile" do
    url "https://files.pythonhosted.org/packages/e3/02/460b31c20833036d8f171b991ff2f46c7f1dc85c6219e8bf7efca4a9aa5a/mediafile-0.17.0.tar.gz"
    sha256 "80c9003fd25d7096a7237e3b58e6ff018ef67f9c39900feafacabac1742c7d3a"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/df/70/1675da133ea92227da41bf5b24e1c66be597ff736a1533ade41da986852f/mutagen-1.48.1.tar.gz"
    sha256 "8f95637ab9f6f305cec6bd1294e197debe207998e3e068596563c74f86b0a173"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/b9/8adc4e1b422b27fd88540ec7bf1f406f77ef393ec070e26fc430e914cde8/platformdirs-4.11.9.tar.gz"
    sha256 "e2c66a8d384596cd98e3c4aea2d761df7bac95d9d8a2cc3946daa8cdafdaebc1"
  end

  resource "pyrate-limiter" do
    url "https://files.pythonhosted.org/packages/62/43/48693393af06b9fffbaea6bb8fe03be3c3f17be5d1423dab347d1aad1dde/pyrate_limiter-4.5.0.tar.gz"
    sha256 "098345fff3a52b84dee9bcf6973f184c8b3ef8d34e1f4f781ac0773e3984598b"
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
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?
    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python3)

    without = ["lap"]
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
