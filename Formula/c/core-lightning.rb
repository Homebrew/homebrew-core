class CoreLightning < Formula
  include Language::Python::Virtualenv

  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v26.04.1/clightning-v26.04.1.zip"
  sha256 "304b19e463c263aabf48d3bec5c92d7c6882654560978a7ba5d30e8aa22a1493"
  license "MIT"
  head "https://github.com/ElementsProject/lightning.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "fbb66ce0e729626d5d6f16e6882c4c6a52ba41344068fae21397535a78ccd0f9"
    sha256 arm64_sequoia: "0b47b4497a243d84c7a1b5a172c9218395b6e98e863aa187ae83ad29c792fbd9"
    sha256 arm64_sonoma:  "2c516a67ccd5d20945c5a2b59252b9e5cacb0beb49bb19f55c08a40dfff402ca"
    sha256 sonoma:        "01c519a85bcb18ff098d60bd4d1342dfba8db7aa69542bf3b54fd6d1ededdcff"
    sha256 arm64_linux:   "395ebb85f91d92debd533cbce5be068e50a85d7abab8577ac242a5a863d94040"
    sha256 x86_64_linux:  "141f1363aeca2cdd2b44eea0bb49d98de62f414005d79cea7ba1ee0c2eaf0708"
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
    url "https://files.pythonhosted.org/packages/59/8a/805404d0c0b9f3d7a326475ca008db57aea9c5c9f2e1e39ed0faa335571c/mako-1.3.11.tar.gz"
    sha256 "071eb4ab4c5010443152255d77db7faa6ce5916f35226eb02dc34479b6858069"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/4f/db/cfac1baf10650ab4d1c111714410d2fbb77ac5a616db26775db562c8fab2/setuptools-82.0.1.tar.gz"
    sha256 "7d872682c5d01cfde07da7bccc7b65469d3dca203318515ada1de5eda35efbf9"
  end

  # Fix `configure` to build on macOS
  # PR ref: https://github.com/ElementsProject/lightning/pull/9072
  patch do
    url "https://github.com/ElementsProject/lightning/commit/94cc566ce345748d4cfc38a67eacecc09ab36114.patch?full_index=1"
    sha256 "aa0e74593d2d4ba3faefaa5528143c0cdf6d2ea0e384b000f020ed7e18e9d8ff"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.14")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

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
