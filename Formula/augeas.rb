class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  url "http://download.augeas.net/augeas-1.12.0.tar.gz"
  sha256 "321942c9cc32185e2e9cb72d0a70eea106635b50269075aca6714e3ec282cb87"

  bottle do
    sha256 "00a45b8b446df0a95c2c45cbe608410df2d7be7787247f4b3a8fc1c2c19b41b6" => :catalina
    sha256 "9a561491e3574dfe2cfe7da2a618c12d02218f88f760de46722d9b603e4f27ba" => :mojave
    sha256 "0e1477f692cf67442dfcaf7c20a24733838df072ec867f59322070a7eaf3f925" => :high_sierra
    sha256 "55b3fab93f2ec4a703dc2bb3b3d58c47375456bdb5f0308e0856b231d309c02d" => :sierra
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "readline"
  uses_from_macos "libxml2"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  def caveats; <<~EOS
    Lenses have been installed to:
      #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
  EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
