class Ettercap < Formula
  desc "Multipurpose sniffer/interceptor/logger for switched LAN"
  homepage "https://ettercap.github.io/ettercap/"
  revision 1
  head "https://github.com/Ettercap/ettercap.git"

  stable do
    url "https://github.com/Ettercap/ettercap/archive/v0.8.2.tar.gz"
    sha256 "f38514f35bea58bfe6ef1902bfd4761de0379942a9aa3e175fc9348f4eef2c81"

    # Fixes CVE-2017-6430.
    patch do
      url "https://github.com/Ettercap/ettercap/commit/4ad7f85dc01202e363659aa473c99470b3f4e1f4.patch?full_index=1"
      sha256 "13be172067e133f64a31b14de434acea261ac795d493897d085958192ac1cdd4"
    end
  end

  bottle do
    rebuild 1
    sha256 "8e248cd983f18f1bb5c8efe25f67b94b928121cc0bc1aecaad30a2b495895a54" => :mojave
    sha256 "0176b4a57909fc8c448df8b0e88b6063267ec80c6de740d597cfffc531ac98c6" => :high_sierra
    sha256 "84b9f55fd615340f552685901bc93f7c9c1a5412f82342a692684aa26b0441d0" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "curl" if MacOS.version <= :mountain_lion # requires >= 7.26.0.
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl"
  depends_on "pcre"
  depends_on "gtk+" => :optional
  depends_on "gtk+3" => :optional

  def install
    args = std_cmake_args + %W[
      -DBUNDLED_LIBS=OFF
      -DENABLE_CURSES=ON
      -DENABLE_IPV6=ON
      -DENABLE_LUA=OFF
      -DENABLE_PDF_DOCS=OFF
      -DENABLE_PLUGINS=ON
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    if build.with?("gtk+") || build.with?("gtk+3")
      args << "-DENABLE_GTK=ON" << "-DINSTALL_DESKTOP=ON"
      args << "-DGTK_BUILD_TYPE=GTK3" if build.with? "gtk+3"
    else
      args << "-DENABLE_GTK=OFF" << "-DINSTALL_DESKTOP=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
