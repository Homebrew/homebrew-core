class Libestr < Formula
  desc "C library for string handling (and a bit more)"
  homepage "https://libestr.adiscon.com/"
  url "https://libestr.adiscon.com/files/download/libestr-0.1.11.tar.gz"
  sha256 "46632b2785ff4a231dcf241eeb0dcb5fc0c7d4da8ee49cf5687722cdbe8b2024"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://libestr.adiscon.com/download/"
    regex(/href=.*?libestr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "25ff0e46e019f6de30b6d9a0980bd1eaaaa6a007f5c815f2e48607c6bab91714"
    sha256 cellar: :any,                 arm64_sequoia:  "c4ee35e1e3e47e5009e3fdb7be52737edebddcdd812e8c1811fcf73648a656cb"
    sha256 cellar: :any,                 arm64_sonoma:   "3fba48207a9ab79341e43e937560dfeae150dada3f5cb560a7a209fb45e726ef"
    sha256 cellar: :any,                 arm64_ventura:  "5acb64697d9ef2237c384b6b2f265e2c74770f218259707485fcdf99dfdca7d5"
    sha256 cellar: :any,                 arm64_monterey: "b186e7aa04c176161a97f6955e2d4cc5dff415be78213f0f842c03acd0614c4e"
    sha256 cellar: :any,                 arm64_big_sur:  "20863614b37a81431737f276b1273bf542e374a323b9a1e486af7775e659d688"
    sha256 cellar: :any,                 sonoma:         "762b4c02935959cf91f8520f6d275cba1cd5f54432201b745e3674c9b29fc5c5"
    sha256 cellar: :any,                 ventura:        "47ab08fd7c8294b4e47eae018b76a6ce91837ec1705b071099cf7d5c65410f15"
    sha256 cellar: :any,                 monterey:       "21c59f29aad1c8053e27ce8946abbc9bb5b82e8ae8672b331524282fd835b60b"
    sha256 cellar: :any,                 big_sur:        "11fa154962682f47b57b2dac7ceee697b5cf57c21e56d3c713f6e5a646d318da"
    sha256 cellar: :any,                 catalina:       "f539c76e3acdd0a93def55a0e82ecf45c53de65dc6dc18fd123efe815d8a65cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9f88fde30fe9005f5eafd6a718b233317c838f741535b789ac39a1a027daf0b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f131de3ed214869ab11a430e48f7e006d8b4ae1c181413f0d60aa9da85f4599"
  end

  depends_on "pkgconf" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "stdio.h"
      #include <libestr.h>
      int main() {
        printf("%s\\n", es_version());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lestr", "-o", "test"
    system "./test"
  end
end
