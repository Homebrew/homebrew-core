class Libjwt < Formula
  desc "JSON Web Token C library"
  homepage "https://github.com/benmcollins/libjwt"
  url "https://github.com/benmcollins/libjwt/releases/download/v1.17.2/libjwt-1.17.2.tar.bz2"
  sha256 "f11c4544f61a31f105720b8329409fea009d6f9ef41c9361f98c2de48152eeae"
  license "MPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e433e0ed22bee9058050751d331c00e6323c0fc72e613ff74f877c64eb062eaa"
    sha256 cellar: :any,                 arm64_sonoma:   "e5e42db60707d394e7b75f12fbd4e893af044e6b8f95f0965d2360be945f54b8"
    sha256 cellar: :any,                 arm64_ventura:  "7155a77451afa2502504166ee1f993d2940491307655baae26574a1e11ad79d4"
    sha256 cellar: :any,                 arm64_monterey: "d146d780d78e589e25e65b60ad3b7d8690919fe5431eba07ef993f2355d9cd87"
    sha256 cellar: :any,                 sonoma:         "88f76ba6d0b19bf5ce7b55606e091bfc3961dc86c63a5316dfd8863bbbc8962f"
    sha256 cellar: :any,                 ventura:        "f2d43fd72ea4c4ddadc55897c08e42d5956e438dae7c4b7761938c86b889d0e5"
    sha256 cellar: :any,                 monterey:       "27b7c6378fadd9a458e54ed4588b14f1f1fd6c9c596302a2853116d4f2249249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91c1b7a6dcfb8a65387ffef2f66c3902510b6e78c00cfa46077b853eb605022e"
  end

  head do
    url "https://github.com/benmcollins/libjwt.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <jwt.h>

      int main() {
        jwt_t *jwt = NULL;
        if (jwt_new(&jwt) != 0) return 1;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-ljwt", "-o", "test"
    system "./test"
  end
end
