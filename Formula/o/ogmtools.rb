class Ogmtools < Formula
  desc "OGG media streams manipulation tools"
  homepage "https://www.bunkus.org/videotools/ogmtools/"
  url "https://www.bunkus.org/videotools/ogmtools/ogmtools-1.5.tar.bz2"
  sha256 "c8d61d1dbceb981dc7399c1a85e43b509fd3d071fb8d3ca89ea9385e6e40fdea"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ogmtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "86153da84a3749d259955192038722ee1f4adc2142f382cc29c2885ec07b348a"
    sha256 cellar: :any,                 arm64_sequoia:  "789b9bad9d0902bf85da322c80b14401105d4307a1affc78e523e9c9e22fd8ce"
    sha256 cellar: :any,                 arm64_sonoma:   "3a941c51496636669cd52f1d4b81195b7dd35c29af3333014f9d34070bdc8dbf"
    sha256 cellar: :any,                 arm64_ventura:  "93842b3845c01a1b3efc05d7b6f3f06957205733537e84a3b743b2df41ba692c"
    sha256 cellar: :any,                 arm64_monterey: "21c37a98fe73b81c34dbeb8abfb29f6bc30bb7af9d1d9b8d7b379667eb84de30"
    sha256 cellar: :any,                 arm64_big_sur:  "34cfdabab2892f91fd6a6164a041f62eef1da1cf7a2097ad5fe5e2e904de21a3"
    sha256 cellar: :any,                 sonoma:         "6648b18de049a3dceb9ea8eccb8285b25227a074017cf624a534547540915d40"
    sha256 cellar: :any,                 ventura:        "fae0d207875e9368c96bd5c20a9daa5f9cc52f02f94819fd97c657d6a15ebf19"
    sha256 cellar: :any,                 monterey:       "0bcb100030a3bea8c804c7dd9091d423997c35e6bb5160251724f7397669f833"
    sha256 cellar: :any,                 big_sur:        "939be64a395371009f70c9c596e86df908e429ad6915dee142752c1114f2e1d3"
    sha256 cellar: :any,                 catalina:       "6a2e3ed95e0569dca709b5d0431ea309c008400f3f88b91133d6854340babed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3608e7bae8ff168511df1e0202734b707d90960e6982c85e65f912b12a5679e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bd76fd65c8b1627890beef905c7b8eb23119ace422c6618be47a9412862479c"
  end

  depends_on "libogg"
  depends_on "libvorbis"

  # Borrow patch from MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/ogmtools/common.h.diff"
    sha256 "2dd18dea6de0d2820221bde8dfea163101d0037196cb2e94cd910808d10119c0"
  end

  def install
    ENV.cxx11

    ENV.append "CPPFLAGS", "-I#{Formula["libvorbis"].opt_include}"
    system "./configure", "--mandir=#{man}", *std_configure_args

    system "make", "install", "LIBS=-L#{Formula["libvorbis"].opt_lib} -lvorbis -lvorbisenc"
  end

  # Borrow warning from MacPorts
  def caveats
    <<~EOS
      Ogmtools has not been updated since 2004 and is no longer being developed,
      maintained or supported. There are several issues, especially on 64-bit
      architectures, which the author will not fix or accept patches for.
      Keep this in mind when deciding whether to use this software.
    EOS
  end
end
