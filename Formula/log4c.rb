class Log4c < Formula
  desc "Logging Framework for C"
  homepage "https://log4c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4c/log4c/1.2.4/log4c-1.2.4.tar.gz"
  sha256 "5991020192f52cc40fa852fbf6bbf5bd5db5d5d00aa9905c67f6f0eadeed48ea"
  license "LGPL-2.1"
  head "https://git.code.sf.net/p/log4c/log4c.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4c[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "3d35b584c96f856ebdc672621ae867fc0d14c56b193bc25fcd3f4b122cd9e250"
    sha256 arm64_monterey: "df3a6f744304902108b48717a9bde9c4f1f19b25f04dbf4b99afb5ca8b55b9f8"
    sha256 arm64_big_sur:  "13c3c642cb9d105c742bb313fde02b1968dee00017ac5fa96e46a908ae43e996"
    sha256 ventura:        "11db7e7c463f17035e79dfd31d906a8b52dbca9802ba7a45239290d337e0a4b7"
    sha256 monterey:       "26f216931900e3f177c8f9158afc9d1beddab45327606f35e180577ec3b4ca27"
    sha256 big_sur:        "fa93c7beb25097d19cd6408e88e1d5bf8019386cdee22beb0f30d1fa7956286e"
    sha256 catalina:       "25859511ac3302318ca6eed1eaa89c5a9b1e91b611da4233604e443d9c016dec"
    sha256 mojave:         "8e35c261de43e25fe934f9f77875ff9c5fa6bdc4297fd0dd2fc657a5acd680ae"
    sha256 high_sierra:    "4019efd84d56e2390feff696e1fa3305b788fdcb3105c5b6117913e81a16a7f2"
    sha256 sierra:         "171a6c3f12f957d5442998f0f02df959aa4376ef543338765930ed4e062ef0ea"
    sha256 el_capitan:     "2334e58e3ae201b28362707d2b64701e2e1378695e915baad886956e4edea50a"
    sha256 x86_64_linux:   "5182c7b11972d29559087012a708f71137b9795294afb833aff1cf9d40168a9a"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/log4c-config", "--version"
  end
end
