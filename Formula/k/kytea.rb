class Kytea < Formula
  desc "Toolkit for analyzing text, especially Japanese and Chinese"
  homepage "https://www.phontron.com/kytea/"
  license "Apache-2.0"

  stable do
    url "https://www.phontron.com/kytea/download/kytea-0.4.7.tar.gz"
    sha256 "534a33d40c4dc5421f053c71a75695c377df737169f965573175df5d2cff9f46"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?kytea[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
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
    sha256 mojave:         "57c8c3acf60417d44d7df27445d667dd03095f1afdad70aeb63cf68e0cbc64c0"
    sha256 high_sierra:    "bcdb450698d5065cf82b7726d6dc21381632c41352237dc547c05cc62e4b7e59"
    sha256 sierra:         "d29c61f74da5f4d88f09d8b540943599ce8b6e5062af88b7d5725ea84fb4c603"
    sha256 el_capitan:     "3e0c66a7efb34ddb8e4f80d9b95562779e224271b8d63d38f9bc8176103427e2"
    sha256 x86_64_linux:   "91e9f57d0c837e62f789d7189349120d1925eca4fa05479072f89b4f617c2ffd"
  end

  head do
    url "https://github.com/neubig/kytea.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"kytea", "--version"
  end
end
