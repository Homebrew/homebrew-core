class Libsigcxx < Formula
  desc "Callback framework for C++"
  homepage "https://libsigcplusplus.github.io/libsigcplusplus/"
  url "https://download.gnome.org/sources/libsigc++/3.0/libsigc++-3.0.0.tar.xz"
  sha256 "50a0855c1eb26e6044ffe888dbe061938ab4241f96d8f3754ea7ead38ab8ed06"

  bottle do
    cellar :any
    sha256 "34d97436f679f9ed9d76a1878d87b29eab692b487cb24aa2b18ba34e6856ab25" => :mojave
    sha256 "ea4710c4dee791bf3109ed28b2cf1d17deb07811f334fc8ff462aafdcf222fc4" => :high_sierra
  end

  depends_on :macos => :high_sierra # needs C++17

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end
  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <sigc++/sigc++.h>

      void on_print(const std::string& str) {
        std::cout << str;
      }

      int main(int argc, char *argv[]) {
        sigc::signal<void(const std::string&)> signal_print;

        signal_print.connect(sigc::ptr_fun(&on_print));

        signal_print.emit("hello world\\n");
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp",
                   "-L#{lib}", "-lsigc-3.0", "-I#{include}/sigc++-3.0", "-I#{lib}/sigc++-3.0/include", "-o", "test"
    assert_match "hello world", shell_output("./test")
  end
end
