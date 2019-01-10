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
    rebuild 2
    sha256 "107e746f7ced82f3af46914005e6f4043d9e03d85d08c79512cd7f3833a99cc2" => :mojave
    sha256 "5006d29356b76d963228389bc9e04e8f15c8851130208ac32d987554308e7aa1" => :high_sierra
    sha256 "a81409380c3025a5eea3a52fb5c6a7de0d865f4477b47ebe3c8cfd580195fcac" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "curl" if MacOS.version <= :mountain_lion # requires >= 7.26.0.
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
