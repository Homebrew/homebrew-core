class Libui < Formula
  desc "portable GUI library for C"
  homepage "https://github.com/andlabs/libui"
  url "https://github.com/andlabs/libui/archive/alpha3.1.tar.gz"
  sha256 "945ee9abacffafa93b5cf941bddfbe0bd0d4b3a8c7f8b0256779e24249f57679"

  head "https://github.com/andlabs/libui/libui.git"

  option "without-shared-library", "Build static library only (defaults to building dylib only)"
  option "with-examples", "Build examples"
  option "with-tester", "Build tester program"

  depends_on "cmake" => :build

  def install
    args = []
    args << "-DBUILD_SHARED_LIBS=OFF" if build.without? "shared-library"
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make"
      system "make", "examples" if build.with? "examples"
      system "make", "tester" if build.with? "tester"

      Dir.chdir("out")
      libexec.install "controlgallery", "cpp-multithread", "histogram" if build.with? "examples"
      libexec.install "test" if build.with? "test"
    end

    include.install "ui.h", "ui_darwin.h"
    lib.install Dir["build/out/libui.*"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ui.h>
      uiWindow *mainwin;
      int main(void) {
        mainwin = uiNewWindow("libui test", 640, 480, 1);
        uiQuit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test",
           "-I#{include}", "-L#{lib}", "-lui",
           "-framework", "Cocoa"
    system "./test"
  end
end
