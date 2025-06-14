class Qgpgme < Formula
  desc "Qt wrapper for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/qgpgme/qgpgme-2.0.0.tar.xz"
  sha256 "15645b2475cca6118eb2ed331b3a8d9442c9d4019c3846ba3f6d25321b4a61ad"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => [:build, :test]
  depends_on "gpgme"
  depends_on "gpgmepp"
  depends_on "libgpg-error"
  depends_on "qt"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_WITH_QT5=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "false"
  end
end
