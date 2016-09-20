class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.6.0.tar.gz"
  sha256 "8ba0d9bf059e7ef52118826d1285f097b399fc7a56756ce28e053da0b3ab69b5"
  revision 1

  bottle do
    sha256 "5dd9f81009041411b1f84c3ace8c3680aa02ee0644fefaa9484ed9261a04d49b" => :sierra
    sha256 "76602a331faa9ff0d86792707c5048651428674ad9d55cac81735aa90d66a601" => :el_capitan
    sha256 "e1403283257616daf8ea431bc27749e0c2ae3eba062f4e0a466336d793d0bccb" => :yosemite
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "readline"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Lenses have been installed to:
      #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
