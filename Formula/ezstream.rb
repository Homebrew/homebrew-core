class Ezstream < Formula
  desc "Client for Icecast streaming servers"
  homepage "https://icecast.org/ezstream/"
  url "https://downloads.xiph.org/releases/ezstream/ezstream-1.0.1.tar.gz"
  sha256 "fc4bf494897a8b1cf75dceefb1eb22ebd36967e5c3b5ce2af9858dbb94cf1157"
  license "GPL-2.0-only"
  head "https://gitlab.xiph.org/xiph/ezstream.git"

  livecheck do
    url "https://downloads.xiph.org/releases/ezstream/"
    regex(/href=.*?ezstream[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "6e4ae956fd62819bb7417528bd7e30c8b95bcbdc313c786d42b41e506ac51667" => :big_sur
    sha256 "3f4febc102766cc55bbb02e099e2b1d111c159ef8e751409f10788e3fbcad335" => :arm64_big_sur
    sha256 "f8ac059c41ccbe5e3f5ec47460cdd52b45c7bc4b3ef9f94fbbb371f26b220549" => :catalina
    sha256 "78ccfbc94038fa03dba4badfc46bfa607154845dbf0b9c5f11066dc6cd013697" => :mojave
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
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m3u").write test_fixtures("test.mp3").to_s
    system bin/"ezstream", "-s", testpath/"test.m3u"
  end
end
