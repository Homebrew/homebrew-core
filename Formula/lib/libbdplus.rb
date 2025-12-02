class Libbdplus < Formula
  desc "Implements the BD+ System Specifications"
  homepage "https://www.videolan.org/developers/libbdplus.html"
  url "https://get.videolan.org/libbdplus/0.2.0/libbdplus-0.2.0.tar.bz2"
  mirror "https://download.videolan.org/pub/videolan/libbdplus/0.2.0/libbdplus-0.2.0.tar.bz2"
  sha256 "b93eea3eaef33d6e9155d2c34b068c505493aa5a4936e63274f4342ab0f40a58"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libbdplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7b8a3164167b5bc2e357f954ae319df5c9d6d7f0fb7b63f4ef71b65cbec9e3a4"
    sha256 cellar: :any,                 arm64_sequoia:  "9cc87d2f97a8450b3757c16b409e1c13a562e2d0e52492ab9d9cb032c908d600"
    sha256 cellar: :any,                 arm64_sonoma:   "ea38d1a6e93c8fcf4d08039d40e2fdc5fc681a66f1e3377c8e9f56a4992136d2"
    sha256 cellar: :any,                 arm64_ventura:  "f47c8d29158db9c810a1f037d3335ba5cb5b8c8c3769c5435d516f07cef44c73"
    sha256 cellar: :any,                 arm64_monterey: "c5e53b35cf902a1b1bed758850dc351c5fa005f78147a39085e284b02ddded9f"
    sha256 cellar: :any,                 arm64_big_sur:  "f4b3ecf7789e87ae8ebc97cf9a3c00321c79a3cca58d7a6679ea686da6c415e3"
    sha256 cellar: :any,                 sonoma:         "71cae25b96b7723171f93ab33b2508cff5f8b081165d124dae5a6639b78a62aa"
    sha256 cellar: :any,                 ventura:        "b4b549364f9d64a044ef9e90f7896f1214fef2c8303dfe3bd376af7b95387233"
    sha256 cellar: :any,                 monterey:       "6e72efd19ac6ebf39f3c22240a1e706cd101540a2c2b55c1c83cf4048642339f"
    sha256 cellar: :any,                 big_sur:        "d0e37545cdc9aa4e23e56dfead1e17ed894431e06bcdc06dec76a4ffb32b6deb"
    sha256 cellar: :any,                 catalina:       "f4887dd87e0d8ef822f629b603436db20ce331bf4105c2b3d5d2864ac82c9e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1f77338b5c92c9187e9ceccd4c0d073227b7e86edac29204f72da202a89259de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6adab3c63417c05c7b4e68bebd99dd6e0d133d7d60e1dcfe29552150cb484e0"
  end

  head do
    url "https://code.videolan.org/videolan/libbdplus.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libbdplus/bdplus.h>
      int main() {
        int major = -1;
        int minor = -1;
        int micro = -1;
        bdplus_get_version(&major, &minor, &micro);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lbdplus", "-o", "test"
    system "./test"
  end
end
