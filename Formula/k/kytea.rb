class Kytea < Formula
  desc "Toolkit for analyzing text, especially Japanese and Chinese"
  homepage "https://www.phontron.com/kytea/"
  license "Apache-2.0"

  stable do
    url "https://www.phontron.com/kytea/download/kytea-0.4.7.tar.gz"
    sha256 "534a33d40c4dc5421f053c71a75695c377df737169f965573175df5d2cff9f46"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end

    # Fix build with newer Clang
    patch do
      url "https://github.com/neubig/kytea/commit/eab98ce9c45ccc4a0226a87fa6c40b6d0c5ba82b.patch?full_index=1"
      sha256 "aabb381b38592432d97f789520c81e6df46808c611ff541aae093357c06921c6"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?kytea[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "5ad912b4301454e3c29c5dd0f9b4c9b592d140d0ecc24cb12261408a7dc5ea56"
    sha256 arm64_sequoia:  "0afb996003e2ad0e1443b6a260fcebf6ae349022a1e082ae467bc96d77000b1f"
    sha256 arm64_sonoma:   "80b6a9d85ab58a17b68cf889c413a5bae57c27839ec5e77a787a2a4ae7753c71"
    sha256 arm64_ventura:  "ef9042105ea5b55cfc0dde6e495c287601ec8aad58d8e14342702e127a7d97dd"
    sha256 arm64_monterey: "5de2fbf7e068e2c61aac03c0b672990f22280ab377d7034dc708d96b5ce76ce6"
    sha256 arm64_big_sur:  "e6507d77b03cee09e01eed90d0eb1c724c8acce9ffb7ad0d75a4dfc7ba434fe8"
    sha256 sonoma:         "e6493b3a4ba931b1ae013e07f3bb2fd642ee195eaaa31ba30a0511b3ba3e24cd"
    sha256 ventura:        "0ec4d5bde1d09dd1b51f2cd047b8e586b1aebadc0a8d418025f778ef68ce1c72"
    sha256 monterey:       "98ff434e2b5ebf881d6090accee434dd9fb6912319cd4113b34fbd59fead6e78"
    sha256 big_sur:        "2efc4bc6d1c77859c5012819331672e30b9e8c4491c696aac132e8356e08b483"
    sha256 catalina:       "927aac3d562cc2977f84670c850ab262a05a010bfe7e7f16aa0eb7d9532eae7b"
    sha256 arm64_linux:    "17f10a2914f947e7ddb494eaae7e76d3d6e36887db809a894f9d824776a47aa3"
    sha256 x86_64_linux:   "91e9f57d0c837e62f789d7189349120d1925eca4fa05479072f89b4f617c2ffd"
  end

  head do
    url "https://github.com/neubig/kytea.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kytea --version 2>&1")
  end
end
