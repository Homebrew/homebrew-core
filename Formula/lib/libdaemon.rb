class Libdaemon < Formula
  desc "C library that eases writing UNIX daemons"
  homepage "https://0pointer.de/lennart/projects/libdaemon/"
  url "https://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz"
  sha256 "fd23eb5f6f986dcc7e708307355ba3289abe03cc381fc47a80bca4a50aa6b834"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libdaemon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "b5a484b80371d6d282f43e26bad28db36b03be6ffb54e54e0a453ab57492c3ef"
    sha256 cellar: :any,                 arm64_sequoia:  "5bb178b81ecf063f093a88970d991bd20550e492496e317a8617b1fb7c8874d4"
    sha256 cellar: :any,                 arm64_sonoma:   "e3311382ce2231961c035a35b3376f3d8ce9c852ca565fe35a971f6d9539b6ef"
    sha256 cellar: :any,                 arm64_ventura:  "48e59b83b13317a14504cc36b820781a8e55e2e11509eeacb3632535daa98988"
    sha256 cellar: :any,                 arm64_monterey: "0ba92f47214e34c065723f4dc24f0a0391b8d0cb9af18b4a0262ab74d6629757"
    sha256 cellar: :any,                 arm64_big_sur:  "d5bebb62e8788d3e229a9022c600d3abc7b93843c854070a6296e6962979a2f0"
    sha256 cellar: :any,                 sonoma:         "7d725995c1dd243717fa590f3dc3bb5996d9584c7e6ed490695f80e4f00357a4"
    sha256 cellar: :any,                 ventura:        "0920b6d606e3afaa3ac023790dc9e7c3f89c99297ae54ae3b9d20cf10e27aee8"
    sha256 cellar: :any,                 monterey:       "90500c4d405d8c04cccb7d06c6c45bed48646e49700d160d44659a22577007fa"
    sha256 cellar: :any,                 big_sur:        "e33a72add1413b788a607ae16413c3434da9d2faca96b9201504121b03a7ff73"
    sha256 cellar: :any,                 catalina:       "ad96f0b0e09c3e0c178d3e903659d65ae34fea18365197924a4911c291d02531"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3f6cddfcdcd44cbd7592ef623e20fffcf98471f6e375e25f23c99b8c0c7198cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66573e3e026fca5fab4dd7e1f7c9712e837fd65ca21cfc1e0687e719d8905c90"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    args = ["--disable-silent-rules"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end
end
