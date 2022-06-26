class Portaudio < Formula
  desc "Cross-platform library for audio I/O"
  homepage "http://www.portaudio.com"
  url "http://files.portaudio.com/archives/pa_stable_v190700_20210406.tgz"
  version "19.7.0"
  sha256 "47efbf42c77c19a05d22e627d42873e991ec0c1357219c0d74ce6a2948cb2def"
  license "MIT"
  version_scheme 1
  head "https://github.com/PortAudio/portaudio.git", branch: "master"

  livecheck do
    url "http://files.portaudio.com/download.html"
    regex(/href=.*?pa[._-]stable[._-]v?(\d+)(?:[._-]\d+)?\.t/i)
    strategy :page_match do |page, regex|
      # Modify filename version (190700) to match formula version (19.7.0)
      page.scan(regex).map { |match| match&.first&.scan(/\d{2}/)&.map(&:to_i)&.join(".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "8f390bc5ee1fffa1191df48e2947acafd5063abdc713c595760f3ac6a7a8ebd6"
    sha256 cellar: :any,                 arm64_big_sur:  "3daf7c4d5a1b948b2564de026336e3f3496f693ea0743e42b50f78d09ee32469"
    sha256 cellar: :any,                 monterey:       "69daed6f99f96edb350f06043d5d7121bb0d3eaa88e64ef5bac247f300d552e9"
    sha256 cellar: :any,                 big_sur:        "f67d3a167142d0afa6ef446260075a7e1c29cf3d1246a95bac2f12732004398a"
    sha256 cellar: :any,                 catalina:       "9b0934f5a868dc0c3874ae6491d685cff6537923cc49d6abea18c1bf59cddaea"
    sha256 cellar: :any,                 mojave:         "e69bcb7966fae64dabb4866a9f791437b59ef1991112b2a6fb31ee94a76b9244"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01048cd3e5c934f5fb7b7cd11430833c69022a621fcc2d868159e07bbef1e3e4"
  end

  depends_on "pkg-config" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  def install
    system "./configure", *std_configure_args,
                          "--enable-mac-universal=no",
                          "--enable-cxx"
    system "make", "install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h" if OS.mac?
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
