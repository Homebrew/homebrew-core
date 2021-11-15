class Madplay < Formula
  desc "MPEG Audio Decoder"
  homepage "https://www.underbit.com/products/mad/"
  url "https://downloads.sourceforge.net/project/mad/madplay/0.15.2b/madplay-0.15.2b.tar.gz"
  sha256 "5a79c7516ff7560dffc6a14399a389432bc619c905b13d3b73da22fa65acede0"

  livecheck do
    url :stable
    regex(%r{url=.*?/madplay[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "a191fb98eafba8ec2b63d6f7089578953d8ed8f2cff51d0cc89b49301da20c42"
    sha256 arm64_big_sur:  "1572c5cf1aa126ed1c9ba15eb77a41dab98a1aa708fc313eaf00211d89f507e0"
    sha256 monterey:       "6cfa0d52586c0aab9510e5acc9f18e5cfcfb0238c1fa08b9562e5cb9ae1d6277"
    sha256 big_sur:        "09143a43e56380a76a9f2e6ebc11897da5dd4898011fa6805ab5fd125dcaba5b"
    sha256 catalina:       "06320361fe8d3687b541149a2c26f78b9a251a813ef7ca1ecfe09e6dfd7ec1b9"
    sha256 mojave:         "04339d670f10b87819965e4bae0e5700840e97e1052313cc62dd5ae6d7e194ce"
    sha256 high_sierra:    "7ff11d9521cb9507f669753e8c862efa44f5673cc009578202c1ec7dcba379d1"
    sha256 sierra:         "a4a1b057547c65f8d793e874632e98ee10bfdae234ff011d16d99593c3fa7853"
    sha256 el_capitan:     "81dbc8781c5da50f7188a4031ed5d500b07c51a7589da6799c6bf3477bb90bf6"
    sha256 yosemite:       "4ab0b6303cafe408494e85c38b80a3c44964953995c024d2b65a019bc5608c05"
    sha256 x86_64_linux:   "ec0f6f04859ba10663c5db4a57641807c0e8c3ae94cff3a2ef94983109314577"
  end

  depends_on "libid3tag"
  depends_on "mad"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f6c5992c/madplay/patch-audio_carbon.c"
    sha256 "380e1a5ee3357fef46baa9ba442705433e044ae9e37eece52c5146f56da75647"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --build=x86_64
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/madplay", "--version"
  end
end
