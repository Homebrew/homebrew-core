class LibxmlxxAT4 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/4.0/libxml++-4.0.2.tar.xz"
  sha256 "933aed23e933694d62434a56c8439e654ed84848323e990dee7880fb819d33bf"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "11d8ea93f58e2b7eae642c6d633471db6152bbfcc8485d72bc101c9db814bd47"
    sha256 cellar: :any, arm64_monterey: "663148c59e702e0103bd896f97df7b7ebf9cecef24595c04d26533e939dbdac7"
    sha256 cellar: :any, arm64_big_sur:  "5a06b967b5dc6dc281ea42119ba403b61adad112847c9917a98d4a6c2a1731a5"
    sha256 cellar: :any, ventura:        "ee8ddb64c2ab91b24b3c1704bd73773634452e4ecd49322292525b65582b9ccb"
    sha256 cellar: :any, monterey:       "915a2709f55796d55ccd6eccc35054532d2836f46ed9afd796289f66ee3ce9ff"
    sha256 cellar: :any, big_sur:        "4305e6cfae1d419e675b50bbb134195ce663f6bfc3c41e4d6c3ab0d4b73a9d58"
    sha256 cellar: :any, catalina:       "0b53bf58284336f912f73e6505d6e0eb30d2f86b0aa337b37f9b53819f091503"
    sha256               x86_64_linux:   "405666cbdc8aaac45ec7cceda7bd73610e7e5e8ddd96701051cfe7758f5781d1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glibmm"

  uses_from_macos "libxml2"

  fails_with gcc: "5"

  def install
    ENV.cxx11
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-4.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
