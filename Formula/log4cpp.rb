class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "http://log4cpp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.1.tar.gz"
  sha256 "35abf332630a6809c969276b1d60b90c81a95daf24c86cfd7866ffef72f9bed0"

  bottle do
    cellar :any
    sha256 "d375586cef8f94bf153f26b32a7db92142619eb390fb6b7e015c2b62c6ea7ed7" => :sierra
    sha256 "2a54503862126d4d4ac872983286eb77356691bb1df4bc2002b6b9000f12a059" => :el_capitan
    sha256 "c5792136bff0c40ad7baa89974c5335aa3ff0f414d5db86b46d90c2f8cf28210" => :yosemite
    sha256 "03fde62de11b82029b872296e675d123dba1895b7a7b0e5431664edcb9815ab5" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
