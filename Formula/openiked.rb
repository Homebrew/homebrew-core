class Openiked < Formula
  desc "IKEv2 daemon - portable version of OpenBSD iked"
  homepage "https://openiked.org"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenIKED/openiked-7.2.tar.gz"
  mirror "https://mirror.edgecast.com/pub/OpenBSD/OpenIKED/openiked-7.2.tar.gz"
  sha256 "55dc270bc40a121f855d949a25a5ffaeb11e7607e8198ec52160ef54b6946845"
  license "ISC"

  bottle do
    sha256                               arm64_ventura:  "fa1992fefc726490f3f1d4c39fab38b58a166ef92f057568d7a12b301e69b2a0"
    sha256                               arm64_monterey: "d19b1b311897b2d3ceeb011d1513af82ad74a4973a2fbca19b29834084409660"
    sha256                               arm64_big_sur:  "50c7cde3052da690766df2957656253061c0c8eb5c60a115427026a9949f9e5f"
    sha256                               ventura:        "17cf1c88086af81156947f67efa974ae08bc288cf05429b18673d77680782b4f"
    sha256                               monterey:       "5e46b35807ba18efad9474854b59dbd0299094c6da105190163ecd26863d8440"
    sha256                               big_sur:        "9ab20c91204bba9a9be46ae57510767ca3847791a9ee6dd9807a260f589df709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f4743e17f811395c252f6dee24b1e69987cbc290c1c107a7615c0f4e5c3063"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"  # openssl@3 conflicts with libevent

  uses_from_macos "bison"

  def install
    system "cmake", "-S", ".", "-B", "build",
                         "-DHOMEBREW=true",
                         "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                         "-DCMAKE_INSTALL_MANDIR=#{man}",
                         *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    libexec.install "build/regress/dh/dhtest"
  end

  service do
    run opt_sbin/"iked"
    keep_alive true
    require_root true
    working_dir etc
  end

  def caveats
    <<~EOS
      config file can be found here:
        #{etc}/iked.conf

      necessary files for configuration can be found here:
        #{etc}/iked/
    EOS
  end

  test do
    system sbin/"iked", "-V"
    system libexec/"dhtest"
  end
end
