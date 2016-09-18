class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.6.0.tar.gz"
  sha256 "8ba0d9bf059e7ef52118826d1285f097b399fc7a56756ce28e053da0b3ab69b5"

  bottle do
    sha256 "9ba53e464f05723d3773474debabfaf94a08536d6829124f63e399cf717c48af" => :sierra
    sha256 "0d4be7cf95a4e444e693686cfdad4be46d55afb9e6f6dd170f5c40747eb29d12" => :el_capitan
    sha256 "44e8818648d4eeaf50096f27bd4697b7edff067a6fa8c4d07c79e51e65191ccc" => :yosemite
    sha256 "cebbc8424a50e1739f273193cc6551f8d6cb53d35b53e748afb0e5796011eca1" => :mavericks
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
