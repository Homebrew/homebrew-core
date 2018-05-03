class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/v4.1.1.tar.gz"
  sha256 "8666a8096162f208fcb6d98799c775ced742a3f414ce1a606a42c66648fa7b85"
  head "https://github.com/pdfpc/pdfpc.git"

  bottle do
    sha256 "7aeffc37817e9a41a770eb2a20b44db49848e44cd265287a399ebc6fae8ae477" => :high_sierra
    sha256 "ff74933c0c4931d12504f5e73dd79c103c3b4e47cf34609e4773560e5ff6e7c1" => :sierra
    sha256 "bd02cc89521cdadfffa97a3cded515b6aad4ace688d71a25c005751b48502fb3" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  def install
    system "cmake", ".", "-DMOVIES=off", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/pdfpc", "--version"
  end
end
