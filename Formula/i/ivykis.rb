class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis/"
  url "https://github.com/buytenh/ivykis/archive/refs/tags/v0.43.2-trunk.tar.gz"
  sha256 "22621ae6a7144039cfb8666ed509b99ea1876d7642021a3505c7351502641103"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]trunk)?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "39b186ef9cd3390cc76db833ff0ff45a534810fdfc76858eff1b53f945613277"
    sha256 cellar: :any,                 arm64_sequoia:  "d76bb73ff8c5001a8347d9f382e2ee49b500773ce56d0a611b8828c856d5b93b"
    sha256 cellar: :any,                 arm64_sonoma:   "041ef153175797ab1ffdc43c6f66792ccab6bf7bb30b0458e9a0e2796c208135"
    sha256 cellar: :any,                 arm64_ventura:  "075569d21dab788f26ae067e2d3b68de653041f8964df56fb49212162657cf77"
    sha256 cellar: :any,                 arm64_monterey: "97757eff18712b8e6e994bf1d84aa89f4d371793117f11e802570af83a2b8fc0"
    sha256 cellar: :any,                 sonoma:         "c70c4ccd6872f0be9b0d0ab49218fca35d43077d6a82be5b541aa4b5573af1f2"
    sha256 cellar: :any,                 ventura:        "ed59e7e11206ff76514c05ab2bbe5bc302bfff40e73959ee3294cb6759640dda"
    sha256 cellar: :any,                 monterey:       "8246dcfdc88e144a353448209a0f86c06e9fce2c4ad05a493648b4db7d70e496"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3b90fe4d18f18d4f598f91f1bc0dca09552f78dc2076f7908574ab19972c3bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63cc7d328a6c1816803b8a4a90377dfe86dfe0ce21d895bc1968e27c46ed083f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test_ivykis.c").write <<~C
      #include <stdio.h>
      #include <iv.h>
      int main()
      {
        iv_init();
        iv_deinit();
        return 0;
      }
    C
    system ENV.cc, "test_ivykis.c", "-L#{lib}", "-livykis", "-o", "test_ivykis"
    system "./test_ivykis"
  end
end
