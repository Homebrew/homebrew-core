class Liboil < Formula
  desc "C library of simple functions optimized for various CPUs"
  homepage "https://wiki.freedesktop.org/liboil/"
  url "https://liboil.freedesktop.org/download/liboil-0.3.17.tar.gz"
  sha256 "105f02079b0b50034c759db34b473ecb5704ffa20a5486b60a8b7698128bfc69"
  # Only liboil/ref/mt19937ar.c is BSD-3-Clause while rest is BSD-2-Clause.
  # The license for liboil/motovec/* is excluded as it is only used on PowerPC.
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]

  livecheck do
    url "https://liboil.freedesktop.org/download/"
    regex(/href=.*?liboil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "2952ae2a44d572b8bda832e965e061747b5ed1213ccd0bf0d7a41675f7498156"
    sha256 cellar: :any,                 arm64_sequoia:  "884af7577129d0a2cf1418f838a9d8057e4f158911797fc6e7ba4e2217ce0182"
    sha256 cellar: :any,                 arm64_sonoma:   "793980d104cfea7e8ee60dc08de451f1d6c208c90ba8faa57d026d6bb36af87b"
    sha256 cellar: :any,                 arm64_ventura:  "d9163cdae71515f1281691a77d77cd635f9f5d0e001eece4ac204f0156ecc393"
    sha256 cellar: :any,                 arm64_monterey: "1301c11b0befc6f72c27cdf4c659caa989c472a4a04d5fda6d1815baff7c381e"
    sha256 cellar: :any,                 arm64_big_sur:  "915b7c9defeb1e3d056cd4ead9442b6da74c033d776a3d29eab11f3a74cc4bc6"
    sha256 cellar: :any,                 sonoma:         "cf3e923c404d532f40761113f021a0410cea450dd2113faf4578bb37bf811e67"
    sha256 cellar: :any,                 ventura:        "05bd717d1d98207ae7534a1fac233d493838f0b919ddcb2af09f8010b687e56e"
    sha256 cellar: :any,                 monterey:       "85dc36f48c6496097f4aa02b580573a1c21a399e418464121a8f935f50a4a951"
    sha256 cellar: :any,                 big_sur:        "ca18b013a3853b8d751276c3aea1891d945cb510fd73c3f6704eeb84aba49216"
    sha256 cellar: :any,                 catalina:       "4568936a9d090ea8a2a349e4009a0b2f0a66edc49c93b4bda1a9c30d6ad64544"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "12a6d9bd59ede96b60e33f1e1ffcf61b0c66bcd0f5886e6c3a0d76730d514985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64127180a4182632dbde62deafdcba4fa391ff4a675e85a6821cebee298887e1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gtk-doc" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    ENV.append "CFLAGS", "-fheinous-gnu-extensions" if ENV.compiler == :clang

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <liboil/liboil.h>
      int main(int argc, char** argv) {
        oil_init();
        return 0;
      }
    C

    flags = ["-I#{include}/liboil-0.3", "-L#{lib}", "-loil-0.3"] + ENV.cflags.to_s.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
