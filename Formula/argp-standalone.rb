class ArgpStandalone < Formula
  desc "Standalone version of arguments parsing functions from GLIBC"
  homepage "https://www.lysator.liu.se/~nisse/misc/"
  url "https://www.lysator.liu.se/~nisse/misc/argp-standalone-1.3.tar.gz"
  sha256 "dec79694da1319acd2238ce95df57f3680fea2482096e483323fddf3d818d8be"

  livecheck do
    url :homepage
    regex(/href=.*?argp-standalone[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d538d7be595c57c757670fbcd922b9335f9a4a47ef16662233e84b2260eb387b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88d3f4bfb3ab27ec4105a6853fa34b94342ab2ad0d7b79248461b3bea52649a6"
    sha256 cellar: :any_skip_relocation, monterey:       "f0ed596672be7b1b893ea07d341bce448470b3448b55e0b5d90f68e7895de7b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "65a3586ad4399576aeb46e497b4ec08577f84764b7a28448ae6882a2c422068d"
    sha256 cellar: :any_skip_relocation, catalina:       "560e1829dce7113479d755380e0e65318a996f0d04d8e0761f24810e9e019e7d"
    sha256 cellar: :any_skip_relocation, mojave:         "fb60d10ba68efda61d1dfdb161bcf9bfa0474c82b03e0579517cb10608aa9aea"
    sha256 cellar: :any_skip_relocation, high_sierra:    "92532fafd8c2cc86b33de0f347496746d8049bb4d1a6ce0948148e0f3c4bca5a"
    sha256 cellar: :any_skip_relocation, sierra:         "10627e72c0e0eb66cbd03a2beb767c06b8edad4bef01914de7f7c6c1be33a356"
    sha256 cellar: :any_skip_relocation, el_capitan:     "798e6ddb78957f9ad33662287b5971aaf3a43f3646e84691d56b3b85ca06d47f"
    sha256 cellar: :any_skip_relocation, yosemite:       "c926ac0ad3b8dbb8c3e08299ade556470f81d3a88eb51dc60e7cfe107da533e8"
  end

  # This patch fixes compilation with Clang.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b5f0ad3/argp-standalone/patch-argp-fmtstream.h"
    sha256 "5656273f622fdb7ca7cf1f98c0c9529bed461d23718bc2a6a85986e4f8ed1cb8"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    lib.install "libargp.a"
    include.install "argp.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <argp.h>

      int main(int argc, char ** argv)
      {
        return argp_parse(0, argc, argv, 0, 0, 0);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-largp", "-o", "test"
    system "./test"
  end
end
