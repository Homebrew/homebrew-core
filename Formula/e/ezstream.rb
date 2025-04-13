class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "https://icecast.org/ezstream/"
  url "https://ftp.osuosl.org/pub/xiph/releases/ezstream/ezstream-1.0.2.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/ezstream/ezstream-1.0.2.tar.gz"
  sha256 "11de897f455a95ba58546bdcd40a95d3bda69866ec5f7879a83b024126c54c2a"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/ezstream/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)ezstream[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34332f32987c8a53a1d5368b7f9a08d46410609e7c82132d8b8e124a51f2b1aa"
    sha256 cellar: :any,                 arm64_sonoma:  "f707c6216526edfd36d62e773bccfbf616dc72071955b6811b60de26d923995b"
    sha256 cellar: :any,                 arm64_ventura: "6f96ec34c4132e9c10c5418f8515f09c113f871e775c3550a35823f6ef97e914"
    sha256 cellar: :any,                 sonoma:        "1fcd81d78cde696329fde5219e6f4137a494afd8212d06219957234822a95bcf"
    sha256 cellar: :any,                 ventura:       "b4403b4d9aa440098ffe49937e5830639f54063bad5b5dd0899baca8b304d345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01f81316dfd43a8f52f0cebf766a635ed67884341968e18090aa76e8a6cf3d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4227d8f8ab41ba89783745d543c132aec8b2e3edef500adce8472f8055f7bca"
  end

  head do
    url "https://gitlab.xiph.org/xiph/ezstream.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "check" => :build
  depends_on "pkgconf" => :build
  depends_on "libshout"
  depends_on "taglib"

  uses_from_macos "libxml2"

  # Work around issue with <sys/random.h> not including its dependencies
  # https://gitlab.xiph.org/xiph/ezstream/-/issues/2270
  patch :p0 do
    url "https://raw.githubusercontent.com/macports/macports-ports/fa368818e58ecee010bd43f3c08e51c523ee8cf6/audio/ezstream/files/sys-types.patch"
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
