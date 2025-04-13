class Libgfshare < Formula
  desc "Library for sharing secrets"
  homepage "https://www.digital-scurf.org/software/libgfshare"
  url "https://www.digital-scurf.org/files/libgfshare/libgfshare-2.0.0.tar.bz2"
  sha256 "86f602860133c828356b7cf7b8c319ba9b27adf70a624fe32275ba1ed268331f"
  license "MIT"

  livecheck do
    url "https://www.digital-scurf.org/files/libgfshare/"
    regex(/href=.*?libgfshare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cb19a495ba9032a4bd0e0c5e52bf818c8283af8b29dcb25a0a2f9bb0338c2880"
    sha256 cellar: :any,                 arm64_sonoma:   "661368852f131d75f48672074dd635d04c95f30f61f1adae25c26db2cdc45dcc"
    sha256 cellar: :any,                 arm64_ventura:  "ff95631a45cf14842a1cb98a7496022a886360fad2d4a9bae3154ebd6113726a"
    sha256 cellar: :any,                 arm64_monterey: "0890a2e8ac99ea0497d467e1ab82bb8fe7a34d0f5cd75c01897f15b12ac65211"
    sha256 cellar: :any,                 arm64_big_sur:  "d8fc2d9c78a69fc3fe30913aeaa6f1dbeea7091d78d50bd6e6fafcf4dc6dc212"
    sha256 cellar: :any,                 sonoma:         "a8a4279f842d2809488dc30fe2ba7509412d0304e2d6f32e125ac80bf683f5cc"
    sha256 cellar: :any,                 ventura:        "72816d2d02cec8f669f242e020e7b2980d9f16f51d8e388b57d77c5257a2775d"
    sha256 cellar: :any,                 monterey:       "72af5816492ac0696211008f72b896eee5485c0227964c7eae8caadba28212d4"
    sha256 cellar: :any,                 big_sur:        "619b6bee51163d432b903899d6d86223824e055124ead1856bc6c4399fef4fca"
    sha256 cellar: :any,                 catalina:       "59d6afbdff08b3b457ae3bf6284859eb200929dbcf38c7a2e4f6025a45fe02dc"
    sha256 cellar: :any,                 mojave:         "23c584fb3f3edcb9516beacb9cc3448c6bd2352ce44063e609d7a3e9aaeadd34"
    sha256 cellar: :any,                 high_sierra:    "0079ff7fef137a59579eb12e9f15087573ad2c19c8d7a4d53e2a7d8d378e6af1"
    sha256 cellar: :any,                 sierra:         "ed8e772e5d4b6c8471aa4d711bd2178b873cce23028bcd3831a51aca67c3485e"
    sha256 cellar: :any,                 el_capitan:     "c50ebaadca206eef93bc6d835f5814e0d640223c2c7e39cd12feff47720c054d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "681eacdb672caf8dd195c5bb9bf891e5bb7c1317eb84e0e81faf1b155dd474ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4439a61e14f81e80009ad0e85a4e2a8183c106161d29e232176faa061ba380ba"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-linker-optimisations",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "test.in"
    system bin/"gfsplit", "test.in"
    system bin/"gfcombine test.in.*"
  end
end
