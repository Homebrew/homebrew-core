class Libntlm < Formula
  desc "Implements Microsoft's NTLM authentication"
  homepage "https://gitlab.com/gsasl/libntlm/"
  url "https://download.savannah.nongnu.org/releases/libntlm/libntlm-1.7.tar.gz"
  sha256 "d805ebb901cbc9ff411e704cbbf6de4d28e7bcb05c9eca2124f582cbff31c0b1"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libntlm/"
    regex(/href=.*?libntlm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a19de329bc94a571183ca05e94a2b5d6ba191f791acec2cc84685edeb7830c92"
    sha256 cellar: :any,                 arm64_ventura:  "6c497f294540cb3d3e7e0d4e30ea323ce98626a266a777afbaa04982fbfd0c7b"
    sha256 cellar: :any,                 arm64_monterey: "f4aa92e91bfce75842ec9ea9800dd43f2d6afa38e11b735d72d0c0ab88845e19"
    sha256 cellar: :any,                 sonoma:         "d4fa60526ecddba17fc60ae7410499f03b779015c2c0e98b50aece688c8e52e8"
    sha256 cellar: :any,                 ventura:        "418598d92ec06810ab33c0db40cc674f0609b4d217a543bc6299c4b3e462abb9"
    sha256 cellar: :any,                 monterey:       "62ddd12d3c8ec321ef216145d37e1151bab4c22e30fb167c8388a6918eef54a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca554f42dd1ae5813bf910251332b7faee13f680fc6b7fb433b8f1ff946ef39"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
    pkgshare.install "config.h", "test_ntlm.c", "test.txt", "lib/md4-stream.c", "lib/md4.c", "lib/md4.h"
    pkgshare.install "lib/byteswap.h" if OS.mac?
  end

  test do
    cp pkgshare.children, testpath
    system ENV.cc, "test_ntlm.c", "md4-stream.c", "md4.c", "-I#{testpath}", "-L#{lib}", "-lntlm",
                   "-DNTLM_SRCDIR=\"#{testpath}\"", "-o", "test_ntlm"
    system "./test_ntlm"
  end
end
