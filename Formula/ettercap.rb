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
    rebuild 3
    sha256 "7b575e75f994e56b90d1aa3df27c83b88f8f87a80fa6823dc54ffcfef44b73c7" => :mojave
    sha256 "b1d4b0c6b767ae1ba71d0db5ba89333797bcd3ce35865261b27b5f086e1d5dc0" => :high_sierra
    sha256 "4aa3fdbe65583074d2ac59b6bf45a5a48386aedcfbea5c105ee41f6f273e6807" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "geoip"
  depends_on "gtk+3"
  depends_on "libnet"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl"
  depends_on "pcre"

  def install
    args = std_cmake_args + %W[
      -DBUNDLED_LIBS=OFF
      -DENABLE_CURSES=ON
      -DENABLE_GTK=ON
      -DENABLE_IPV6=ON
      -DENABLE_LUA=OFF
      -DENABLE_PDF_DOCS=OFF
      -DENABLE_PLUGINS=ON
      -DGTK_BUILD_TYPE=GTK3
      -DINSTALL_DESKTOP=ON
      -DINSTALL_SYSCONFDIR=#{etc}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ettercap --version")
  end
end
