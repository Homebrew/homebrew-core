class Juise < Formula
  desc "JUNOS user interface scripting environment"
  homepage "https://github.com/Juniper/juise/wiki"
  url "https://github.com/Juniper/juise/releases/download/0.9.0/juise-0.9.0.tar.gz"
  sha256 "7eb7985944b7322fe290f4e5a080a4018ed84bf576e23b8a32e3f94eb13f4c27"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sequoia:  "6af556ee98a8a762f5721c50f86c9048a55746ff3cb3dabf2e2cc20779fd3c6e"
    sha256 arm64_sonoma:   "b395c2ab2ea0eb3b6bd27e6a22c6e4f42c25ecec3e4234fc1cb93043fe045ef9"
    sha256 arm64_ventura:  "aa41977eccd9e96859f15b224c284e7c023c2ecb295bbe26d623f8e4a6a17428"
    sha256 arm64_monterey: "75d29b3e43dcb50f2d05c5884bfdd6c224c6bcd161461e9dff7f8a5c2ca26933"
    sha256 arm64_big_sur:  "27e5253d1f9c4097ce65306fab5689df20dfcb66b7e99b11e746c133317f8b48"
    sha256 sonoma:         "a1616ba910311fb31b7b2c4810c244d954da00c226598f095308306a03942790"
    sha256 ventura:        "597982298bf83522dc6b1747e08662041e859098429a7abcceee51832d852b52"
    sha256 monterey:       "0a10cc6f4e1b94150ef308fd6820d7afc744b8fd99d0dfbbf88688423b174246"
    sha256 big_sur:        "956422c77715dd1009711ce4e3766511edf8ce146057506e5a7154eacdf4ff62"
    sha256 catalina:       "fdc8151a4937275308e7d353b0f42007e5a371a58551c2609351ac9ae0647bbb"
    sha256 mojave:         "7895026372337e9a86c906b364f5a3bda3c217e6def31b6e51ada8ab14c9334b"
    sha256 high_sierra:    "6c4e884c63521014cd059e59372130ea70a06067769aaaf79497cb1f6877c41a"
    sha256 x86_64_linux:   "7130ee133efb52f271435ff4ace122428e1706c561e5ef6c2eecea524b342d4b"
  end

  head do
    url "https://github.com/Juniper/juise.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "libslax"

  def install
    system "sh", "./bin/setup.sh" if build.head?

    # Prevent sandbox violation where juise's `make install` tries to
    # write to "/usr/local/Cellar/libslax/0.20.1/lib/slax/extensions"
    # Reported 5th May 2016: https://github.com/Juniper/juise/issues/34
    inreplace "configure",
      "SLAX_EXTDIR=\"`$SLAX_CONFIG --extdir | head -1`\"",
      "SLAX_EXTDIR=\"#{lib}/slax/extensions\""

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make", "install"
  end

  test do
    assert_equal "libjuice version #{version}", shell_output("#{bin}/juise -V").lines.first.chomp
  end
end
