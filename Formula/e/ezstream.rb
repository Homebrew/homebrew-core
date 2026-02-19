class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "https://icecast.org/ezstream/"
  url "https://ftp.osuosl.org/pub/xiph/releases/ezstream/ezstream-1.0.2.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/ezstream/ezstream-1.0.2.tar.gz"
  sha256 "11de897f455a95ba58546bdcd40a95d3bda69866ec5f7879a83b024126c54c2a"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/ezstream/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)ezstream[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "985d55fee7a55d60c0d2cfa98a71f35e87b1e03272c9ecece67e267e14f53eae"
    sha256 cellar: :any,                 arm64_sequoia: "6d75b37759ae3b6c4345e1ed4a137e860919c432e918b68e706937f99c049b90"
    sha256 cellar: :any,                 arm64_sonoma:  "886d97ef61a1b7cf365634c4c1ffe893cc50242f1cc228e6d22a92f418bb4735"
    sha256 cellar: :any,                 sonoma:        "9d21015b77c920498b613d65a7467749cb595e76a48358ddd7461cf8c3eb1d13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "953f775b15e5a138f324c0a65ac9147202c683d4ca3395e3d7718c3c30045772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff747b5e7626436d26008c0c4f328e9817e6bf61b78ec187e2dab279cea25029"
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
