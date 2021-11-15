class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "https://icecast.org/ezstream/"
  url "https://downloads.xiph.org/releases/ezstream/ezstream-1.0.2.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/ezstream/ezstream-1.0.2.tar.gz"
  sha256 "11de897f455a95ba58546bdcd40a95d3bda69866ec5f7879a83b024126c54c2a"
  license "GPL-2.0-only"

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/ezstream/?C=M&O=D"
    regex(/href=.*?ezstream[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "22efe55635691409ca6c53eda5be73a7667c8ca59f0076b46380b67e663f5283"
    sha256 cellar: :any,                 arm64_big_sur:  "188838a38d3573fc77ffd5684e0e7759b24d550ffdd895243425e13c29e038c2"
    sha256 cellar: :any,                 monterey:       "07ec03e5e37aee0593f5d9121b9bc0ccb071df6c5ee520fc619991820ca90f31"
    sha256 cellar: :any,                 big_sur:        "fbfe1082559a1313ee3ff071ad35866fb20d5fb360fbfc634fbf85ac48c3e94d"
    sha256 cellar: :any,                 catalina:       "2854c21def8d7e97747aeca5e856833d17780698739e581a192059c58f50ffa2"
    sha256 cellar: :any,                 mojave:         "cfc4088a51cdcb0a586ee2a796d5a515d89007bebfae0f7bfd6b2a4c7a2c13f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c88f43345c0ebb3eca025869b579fa86820e12268fdb0e79d77fa2ee16a296"
  end

  head do
    url "https://gitlab.xiph.org/xiph/ezstream.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "libshout"
  depends_on "taglib"

  uses_from_macos "libxml2"

  # Work around issue with <sys/random.h> not including its dependencies
  # https://gitlab.xiph.org/xiph/ezstream/-/issues/2270
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/fa36881/audio/ezstream/files/sys-types.patch"
    sha256 "a5c39de970e1d43dc2dac84f4a0a82335112da6b86f9ea09be73d6e95ce4716c"
  end

  def install
    system "autoreconf", "--verbose", "--install", "--force" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.m3u").write test_fixtures("test.mp3").to_s
    system bin/"ezstream", "-s", testpath/"test.m3u"
  end
end
