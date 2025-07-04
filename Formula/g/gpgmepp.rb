class Gpgmepp < Formula
  desc "C++ bindings for gpgme"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgmepp/gpgmepp-2.0.0.tar.xz"
  sha256 "d4796049c06708a26f3096f748ef095347e1a3c1e570561701fe952c3f565382"
  license "LGPL-2.1-or-later"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "false"
  end
end
