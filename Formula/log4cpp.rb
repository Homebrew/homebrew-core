class Log4cpp < Formula
  desc "Configurable logging for C++"
  homepage "https://log4cpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/log4cpp/log4cpp-1.1.x%20%28new%29/log4cpp-1.1/log4cpp-1.1.3.tar.gz"
  sha256 "2cbbea55a5d6895c9f0116a9a9ce3afb86df383cd05c9d6c1a4238e5e5c8f51d"

  bottle do
    cellar :any
    sha256 "db55c3b9dff2f2248d96c71672cb6032efc16a4803ce12dd52c278bd14b9abc8" => :sierra
    sha256 "dee0bf8b96b1d0de3beb5f2d23cf1e868e6dfd3ec9814e2c4c5eab21432d73e3" => :el_capitan
    sha256 "19e858f7cf8e47d1c10be1c379feb9faae36d78274a53a4240dcab813a3e382c" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
