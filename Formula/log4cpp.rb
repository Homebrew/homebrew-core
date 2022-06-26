class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "https://log4cpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.3.tar.gz"
  sha256 "2cbbea55a5d6895c9f0116a9a9ce3afb86df383cd05c9d6c1a4238e5e5c8f51d"
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?/log4cpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ef34de1a9e3603252d924f37dc222b427287b26843603ca329bc395d3a0c4d2"
    sha256 cellar: :any,                 arm64_big_sur:  "6d5fcedb4afd7681c3ed5e6e65b300487527789144183e854d846a335c26b545"
    sha256 cellar: :any,                 monterey:       "8a710781fbbb6e0bf127e73411aefc490e63f2e17830f269039e0d865601974c"
    sha256 cellar: :any,                 big_sur:        "ff54331ebc21d9e5bcc75faf5af6750ce944485bd6cac293bd879c04c762dc7c"
    sha256 cellar: :any,                 catalina:       "3e08cff5384ae60222e67b63aadfda07534daa4d962b66167c5ffd8c1a55edf7"
    sha256 cellar: :any,                 mojave:         "0e0950a9b99a406b035e13c8acae673ce190a436920940d8150abe0c90cf1e84"
    sha256 cellar: :any,                 high_sierra:    "a80304325ab0f551054b169320c6f726f1c8a78d56eb56e7f14793c0f8cc8836"
    sha256 cellar: :any,                 sierra:         "db55c3b9dff2f2248d96c71672cb6032efc16a4803ce12dd52c278bd14b9abc8"
    sha256 cellar: :any,                 el_capitan:     "dee0bf8b96b1d0de3beb5f2d23cf1e868e6dfd3ec9814e2c4c5eab21432d73e3"
    sha256 cellar: :any,                 yosemite:       "19e858f7cf8e47d1c10be1c379feb9faae36d78274a53a4240dcab813a3e382c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa93ce1f4cce44107a131667b2350814eb79a762c63c8bd4f35d283f21a25a10"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
