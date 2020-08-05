class Cutter < Formula
  desc "Unit Testing Framework for C and C++"
  homepage "https://cutter.osdn.jp/"
  url "https://osdn.mirror.constant.com/cutter/71616/cutter-1.2.7.tar.gz"
  sha256 "4d80feb16f8f4d8eed62bca40194f8896e70bdac06305bf612b41601e659cae6"
  head "https://github.com/clear-code/cutter.git"

  bottle do
    sha256 "0650d1181d339e3d89b8d4965fb2be8c0c69aa59766a09a96ed3eb8bf8d46307" => :catalina
    sha256 "e0022aa0b542412a57d955ca8fb452ad039f7f88657ec1f76ad3820a12f3d96e" => :mojave
    sha256 "28f8f560c992d67b7ae44d64b70476ed8f82b5df9aa1c9183babfb4723df1b55" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-goffice",
                          "--disable-gstreamer",
                          "--disable-libsoup"
    system "make"
    system "make", "install"
  end

  test do
    touch "1.txt"
    touch "2.txt"
    system bin/"cut-diff", "1.txt", "2.txt"
  end
end
