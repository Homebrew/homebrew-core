class Portaudio < Formula
  desc "Cross-platform library for audio I/O"
  homepage "http://www.portaudio.com"
  url "http://files.portaudio.com/archives/pa_stable_v190700_20210406.tgz"
  version "19.7.0"
  sha256 "47efbf42c77c19a05d22e627d42873e991ec0c1357219c0d74ce6a2948cb2def"
  license "MIT"
  version_scheme 1
  head "https://github.com/PortAudio/portaudio.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "50a45425f5c6026788791370b1ba30b0dcc82b6cedacd2240168f57f9abe6484"
    sha256 cellar: :any, big_sur:       "f9ae97164b4101048870c761b15998e46f40da666c3f0e20c33cf6ce2f7319d0"
    sha256 cellar: :any, catalina:      "8b87696f44cf2220cff66b9bcfa105f6a58dfec4eb2a881409e37773494c84b4"
    sha256 cellar: :any, mojave:        "a2cab0bc4fee9757af7269408eb91df07ddeddfa6dd35c9740aae93816622b0b"
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
