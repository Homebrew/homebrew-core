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
    rebuild 1
    sha256 "4c6f13019388fc1763de6941ec72fcd01c84f89ccea53575d6d33f0d16aa8cc2" => :sierra
    sha256 "78d99a6512f411e12aede3e62ac9e1cceb4fc8d182073d3e2a6f60e65c387e2f" => :el_capitan
    sha256 "e52067f235b82d537b44b33048eaa43381c5a4d4185da999d583812f6e4f9ff9" => :yosemite
    sha256 "c032773623fd2cb49b736c6978fa7a765468d8a804f3f8618ecda5fcdd198499" => :mavericks
    sha256 "1386972e0632b4ebe2b2770f1ade4c5921c7726fb7fa70f764f5fe09df085c5e" => :mountain_lion
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
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "portaudio.h"

      int main(){
        printf("%s",Pa_GetVersionInfo()->versionText);
      }
    EOS

    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include "portaudiocpp/System.hxx"

      int main(){
        std::cout << portaudio::System::versionText();
      }
    EOS

    system ENV.cc, testpath/"test.c", "-lportaudio", "-o", "test"
    system ENV.cxx, testpath/"test.cpp", "-lportaudiocpp", "-o", "test_cpp"
    assert_match version.to_s, shell_output(testpath/"test")
    assert_match version.to_s, shell_output(testpath/"test_cpp")
  end
end
