class EbookTools < Formula
  desc "Access and convert several ebook formats"
  homepage "https://sourceforge.net/projects/ebook-tools/"
  url "https://downloads.sourceforge.net/project/ebook-tools/ebook-tools/0.2.2/ebook-tools-0.2.2.tar.gz"
  sha256 "cbc35996e911144fa62925366ad6a6212d6af2588f1e39075954973bbee627ae"
  revision 3

  bottle do
    cellar :any
    sha256 "0ded91b65a0089ca96619fbdf39c1f55ffe18b1b6786077162b2f7d89602fc7a" => :high_sierra
    sha256 "c6e286e88e063821bec84c5d7589e24da162568abee86c7a14a3c49a47fdcfee" => :sierra
    sha256 "3da2cbaf77b390a4c5fdc216483e15ce38d87c151e6365fbc9f9a4b1c501d7b1" => :el_capitan
    sha256 "0d90d2e7ff07b4dc30f40fe769f9e8805b8dee163f44ecc9d7a529064d37c70d" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "libzip"

  def install
    system "cmake", ".",
                    "-DLIBZIP_INCLUDE_DIR=#{Formula["libzip"].lib}/libzip/include",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/einfo", "-help"
  end
end
