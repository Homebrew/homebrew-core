class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20240808-3.1.tar.gz"
  version "20240808-3.1"
  sha256 "5f0573349d77c4a48967191cdd6634dd7aa5f6398c6a57fe037cc02696d6099f"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e138b0994b5fad0a3ccf46324e49b91a11620876f89228c7a39f6b71bef74138"
    sha256 cellar: :any,                 arm64_sonoma:   "1b2f271a1d771dc8fca96672fd33b564508d47d4af3450e704ed6d1a0337fdd2"
    sha256 cellar: :any,                 arm64_ventura:  "7443c1df6b2898548a22e8b0210a75418c9673ae9930a1c1f5c3908dc1da66ba"
    sha256 cellar: :any,                 arm64_monterey: "b278fa5ff18ed71504139964cc50926de622036e0917dfe268e93888ece63e4f"
    sha256 cellar: :any,                 sonoma:         "c4906d27a10fe0317c1641366586a0188f02e8620ddcab99a30d5cd4d19f95f9"
    sha256 cellar: :any,                 ventura:        "198740611f787c5704c53bea9ab99cde30a0266184aaf8a84cf37b40d4c83da7"
    sha256 cellar: :any,                 monterey:       "9ec96e9f9d9e00cb0a2bfecee5c4f36caf5b12a39353241d351e74d515227eda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e574e7c9d236e3c6d12b208934ebe3159e27b50bfd700f73fad765b67ce86e8"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
