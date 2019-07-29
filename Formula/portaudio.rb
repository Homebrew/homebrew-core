class Portaudio < Formula
  desc "Cross-platform library for audio I/O"
  homepage "http://www.portaudio.com"
  url "http://www.portaudio.com/archives/pa_stable_v190600_20161030.tgz"
  version "19.6.0"
  sha256 "f5a21d7dcd6ee84397446fa1fa1a0675bb2e8a4a6dceb4305a8404698d8d1513"
  version_scheme 1
  head "https://git.assembla.com/portaudio.git"

  bottle do
    cellar :any
    sha256 "54d0d7a2e270221cef38c5405a5102a0efc19df4aa88d907d74d0eefebbc31ba" => :mojave
    sha256 "c8c55723ecdb61b8e4f4431062814d6ce8a267a19fe3e34c70b2bd677a0e20f9" => :high_sierra
    sha256 "4fb62387583b02607e013f376c02b4a1f6c2a2fa9b68ee43e79c9c04d12f9a45" => :sierra
    sha256 "96afa37e0de1723e4fa206360f189ed0486ecd74a5554dcab75eb47395be78db" => :el_capitan
    sha256 "64b21e55c28066264ee09918c045b77c0b1049a19f8df4636283ce17b1d84944" => :yosemite
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
