class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.12/libupnp-1.14.12.tar.bz2"
  sha256 "091c80aada1e939c2294245c122be2f5e337cc932af7f7d40504751680b5b5ac"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e0e28944bb650a4117abad5184f841ea6fab69ed4c51734fb85ec4a2236452e0"
    sha256 cellar: :any,                 arm64_big_sur:  "e9294a1fc82e762c9b6b58ea597ac2521ee18b20daf52750a57f8c6840c4ef26"
    sha256 cellar: :any,                 monterey:       "20b34136d8c35fafaab57fd2e34e11ce012c3dd19ecddafdccccc9b85225a4a8"
    sha256 cellar: :any,                 big_sur:        "b038bdfae801804287fab05ada50d13e12e7b5fa270a962f686ada7231034b07"
    sha256 cellar: :any,                 catalina:       "dcea4c1c6884035cfe6b8be048f8f7998e295a5d611f7549e87e89c549c9433f"
    sha256 cellar: :any,                 mojave:         "12fcbdaceb3fd68ee85a4dc9905dee1f92fe656a8b6f90460cf1864249faf24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43231a7cdf7f0b91510dbd5a94d9f120e4f9cbea9d0b7805878a2986218fd207"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
