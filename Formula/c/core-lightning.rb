class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v26.06.1/clightning-v26.06.1.zip"
  sha256 "22fb2b3cc7c96b6c2c8dd86818eeaa6c259d0eba4233b71490277f2e5a1253f7"
  license "MIT"
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "13a5012f1103ac668c1308c8fc6a53a9fd1c6e4a9b654d34dd73436ca5b18a3a"
    sha256 arm64_sequoia: "978409064153d2621e6bd2cdf13f32074b8be51b7e25189caa01475aa35fa4b2"
    sha256 arm64_sonoma:  "49ef3a34805f14b77c5aa04e0b2d23c9c600dc02676f87fae4808fa06351716b"
    sha256 sonoma:        "e45f2a85e83b1e12dd1c3e2a9f4ce1bcbc6aec022248415571d8faa70684caae"
    sha256 arm64_linux:   "5b0903407a11056725c045d9316792cb9fb5afc39441d970079640058e91cbc3"
    sha256 x86_64_linux:  "f63b63ce532bcf732bf9e8904d3df8a1de41766d9ab7feaf2bb9354e05b554d1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.14" => :build
  depends_on "rust" => :build
  depends_on "uv" => :build
  depends_on "bitcoin"
  depends_on "libsodium"
  depends_on "sqlite"

  uses_from_macos "jq" => :build, since: :sequoia
  uses_from_macos "python"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages package_name:   "",
                extra_packages: ["mako", "setuptools"]

  resource "mako" do
    url "https://files.pythonhosted.org/packages/00/62/791b31e69ae182791ec67f04850f2f062716bbd205483d63a215f3e062d3/mako-1.3.12.tar.gz"
    sha256 "9f778e93289bd410bb35daadeb4fc66d95a746f0b75777b942088b7fd7af550a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.14")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    # Fix `configure` to build on macOS
    # PR ref: https://github.com/ElementsProject/lightning/pull/9072
    inreplace "configure", "-Wl,--gc-sections -c $TMPCFILE", "-Wl,--gc-sections $TMPCFILE"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    rm_r Dir["#{bin}/*.dSYM"]
  end

  test do
    lightningd_output = shell_output("#{bin}/lightningd --daemon --network regtest --log-file lightningd.log 2>&1", 1)
    assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end
