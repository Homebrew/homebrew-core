class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://bitbucket.org/wez/atomicparsley/overview/"
  url "https://bitbucket.org/dinkypumpkin/atomicparsley/downloads/atomicparsley-0.9.6.tar.bz2"
  sha256 "49187a5215520be4f732977657b88b2cf9203998299f238067ce38f948941562"
  head "https://bitbucket.org/wez/atomicparsley", :using => :hg

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ea4399b0ed2025590068deda729e9c566094cda9a9e38149e116d97fc6d034d4" => :high_sierra
    sha256 "345eb5a19de38e476a0b39627ea243efdfc9a7a7dd980e5e51e4db74599c3f20" => :sierra
    sha256 "b43ba5577c7e8b2dd9b4852a5d6652e1600a460584096646f38b69b7d103cee9" => :el_capitan
    sha256 "b1825326c53079bd37a098cf100ae29d2b2763c985be0f2592ba89f10b914eb3" => :yosemite
    sha256 "8797e94e5a1083d41fd9843a94362a714a48430918ed95fa9d7f37b31e0ba1e9" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fix Xcode 9 pointer warnings
  # https://bitbucket.org/wez/atomicparsley/issues/52/xcode-9-build-failure
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/ac8624c36e/atomicparsley/xcode9.patch"
      sha256 "15b87be1800760920ac696a93131cab1c0f35ce4c400697bb8b0648765767e5f"
    end
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/atomicparsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/atomicparsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
