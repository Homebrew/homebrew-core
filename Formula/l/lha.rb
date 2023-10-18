class Lha < Formula
  desc "Utility for creating and opening lzh archives"
  homepage "https://lha.osdn.jp/"
  # Canonical: https://osdn.net/dl/lha/lha-1.14i-ac20050924p1.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/lha/22231/lha-1.14i-ac20050924p1.tar.gz"
  version "1.14i-ac20050924p1"
  sha256 "b5261e9f98538816aa9e64791f23cb83f1632ecda61f02e54b6749e9ca5e9ee4"
  license "MIT"

  # OSDN releases pages use asynchronous requests to fetch the archive
  # information for each release, rather than including this information in the
  # page source. As such, we identify versions from the release names instead.
  # The portion of the regex that captures the version is looser than usual
  # because the version format is unusual and may change in the future.
  livecheck do
    url "https://osdn.net/projects/lha/releases/"
    regex(%r{href=.*?/projects/lha/releases/[^>]+?>\s*?v?(\d+(?:[.-][\da-z]+)+)}im)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00c0d551ed3318b4e5bbcac323c3c7135991007b3e149c9a8c9d591491272c47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5c086e5d925a20f9582a1685c1ed5e94df7fadeab034fb5a776a83285297a8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f36323fc8887aa0dfb1ad6897f3c097eebe199b80ec6e873e3c121dd286df627"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d328d1b1740353a2e04c6f79dc863f3fa2caca9380e76b3e48b4b72f5e1ad32b"
    sha256 cellar: :any_skip_relocation, sonoma:         "74087234a9e14c534ccd09049cd0a738f585d178a1da516c0ccc5f5c5e8568a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b6181ea6e55fbcab6912619285b287461e24aa97419b68285b5e3fe0009913df"
    sha256 cellar: :any_skip_relocation, monterey:       "530aa92b0d3fbfdfaa01c6fb94e7a3dd4e98927055589a586145e8c7f5415bd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd78eb55cbce8091fd07d82ec486bfd67fc8079b2fe6385c8374b2e7c5171528"
    sha256 cellar: :any_skip_relocation, catalina:       "429d3165a0f986e815f09ea3f6b2d93e1bd0feef01b6df6159a983e8118244a4"
    sha256 cellar: :any_skip_relocation, mojave:         "12b5c79de56f71138c64d517ffc0091bc313f4cc0f174e10276b248b06e2fa0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8b7a7201b538cc3ef658c5b8cb0512fbd02bad5cff1fda24c89a2c0e18e0817"
  end

  head do
    url "https://github.com/jca02266/lha.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  conflicts_with "lhasa", because: "both install a `lha` binary"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "autoreconf", "-is" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/lha", "c", "foo.lzh", "foo"
    assert_equal "::::::::\nfoo\n::::::::\ntest",
      shell_output("#{bin}/lha p foo.lzh")
  end
end
