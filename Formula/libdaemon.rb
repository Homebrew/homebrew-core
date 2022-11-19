class Libdaemon < Formula
  desc "C library that eases writing UNIX daemons"
  homepage "https://0pointer.de/lennart/projects/libdaemon/"
  url "https://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz"
  sha256 "fd23eb5f6f986dcc7e708307355ba3289abe03cc381fc47a80bca4a50aa6b834"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?libdaemon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "48e59b83b13317a14504cc36b820781a8e55e2e11509eeacb3632535daa98988"
    sha256 cellar: :any,                 arm64_monterey: "0ba92f47214e34c065723f4dc24f0a0391b8d0cb9af18b4a0262ab74d6629757"
    sha256 cellar: :any,                 arm64_big_sur:  "d5bebb62e8788d3e229a9022c600d3abc7b93843c854070a6296e6962979a2f0"
    sha256 cellar: :any,                 ventura:        "0920b6d606e3afaa3ac023790dc9e7c3f89c99297ae54ae3b9d20cf10e27aee8"
    sha256 cellar: :any,                 monterey:       "90500c4d405d8c04cccb7d06c6c45bed48646e49700d160d44659a22577007fa"
    sha256 cellar: :any,                 big_sur:        "e33a72add1413b788a607ae16413c3434da9d2faca96b9201504121b03a7ff73"
    sha256 cellar: :any,                 catalina:       "ad96f0b0e09c3e0c178d3e903659d65ae34fea18365197924a4911c291d02531"
    sha256 cellar: :any,                 mojave:         "1fe52d810eca4471b4d285de02a09ea9e4b78d762f1a2a292d6da1eb10e9626d"
    sha256 cellar: :any,                 high_sierra:    "0933bb1dde0237f4079fefcd228ea644be36fbf814aa96762ebbae3537886558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66573e3e026fca5fab4dd7e1f7c9712e837fd65ca21cfc1e0687e719d8905c90"
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
