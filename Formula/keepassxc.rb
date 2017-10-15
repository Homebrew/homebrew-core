class Keepassxc < Formula
  desc "QT based application to secure and manage personal data"
  homepage "https://www.keepassxc.org/"
  url "https://github.com/keepassxreboot/keepassxc/releases/download/2.2.1/keepassxc-2.2.1-src.tar.xz"
  sha256 "6761cdcef482941d958557466bb113be2c514b9847b0d0a65c7f5ef2c6d67dbe"
  head "https://github.com/keepassxreboot/keepassxc.git"

  depends_on "cmake" => :build

  # Per upstream - "Need g++ 4.7 or clang++ 3.0".
  fails_with :clang if MacOS.version <= :snow_leopard
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  depends_on "qt"
  depends_on "libgcrypt"
  depends_on "lzlib"

  def install
    mkdir "build" do
      # cmake -DWITH_TESTS=OFF ..
      p "std cmake args: #{std_cmake_args}"
      system "cmake", "..", *std_cmake_args
      system "make", "-j8"
      p ["make", "DESTDIR=#{bin}", "install"].join(" ")
      system "make", "DESTDIR=#{bin}", "install"
    end
  end

  test do
    system "#{bin}/usr/local/bin/keepassxc-cli --help"
  end
end
