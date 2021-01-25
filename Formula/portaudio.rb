class Portaudio < Formula
  desc "Cross-platform library for audio I/O"
  homepage "http://www.portaudio.com"
  url "http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz"
  version "19.6.0"
  sha256 "f5a21d7dcd6ee84397446fa1fa1a0675bb2e8a4a6dceb4305a8404698d8d1513"
  version_scheme 1
  head "https://github.com/PortAudio/portaudio.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "15cafef0378ce5a162f4210be1809c22358ca22bfd6f199fb8fe0448ef9f4812" => :big_sur
    sha256 "f28bf56e8387efa44468a1dd8b6b57a0075580a4a27d075a762469ef244f94d2" => :arm64_big_sur
    sha256 "752ecb3b066e413e83b40c2d9f1170927a600711deccb3ca861fc4a4137622f7" => :catalina
    sha256 "7aaae4d4ce8ecabf6470178d71aa826ea2808009ceb602cb52fa17658d34cc61" => :mojave
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-mac-universal=no",
                          "--enable-cxx"
    system "make", "install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "portaudio.h"

      int main(){
        printf("%s",Pa_GetVersionInfo()->versionText);
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include "portaudiocpp/System.hxx"

      int main(){
        std::cout << portaudio::System::versionText();
      }
    EOS

    system ENV.cc, testpath/"test.c", "-I#{include}", "-L#{lib}", "-lportaudio", "-o", "test"
    system ENV.cxx, testpath/"test.cpp", "-I#{include}", "-L#{lib}", "-lportaudiocpp", "-o", "test_cpp"
    assert_match stable.version.to_s, shell_output(testpath/"test")
    assert_match stable.version.to_s, shell_output(testpath/"test_cpp")
  end
end
