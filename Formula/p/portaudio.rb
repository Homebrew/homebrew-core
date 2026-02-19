class Portaudio < Formula
  desc "Cross-platform library for audio I/O"
  homepage "https://www.portaudio.com"
  url "https://files.portaudio.com/archives/pa_stable_v190700_20210406.tgz"
  version "19.7.0"
  sha256 "47efbf42c77c19a05d22e627d42873e991ec0c1357219c0d74ce6a2948cb2def"
  license "MIT"
  version_scheme 1
  head "https://github.com/PortAudio/portaudio.git", branch: "master"

  livecheck do
    url "https://files.portaudio.com/download.html"
    regex(/href=.*?pa[._-]stable[._-]v?(\d+)(?:[._-]\d+)?\.t/i)
    strategy :page_match do |page, regex|
      # Modify filename version (190700) to match formula version (19.7.0)
      page.scan(regex).map { |match| match[0].scan(/\d{2}/).map(&:to_i).join(".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "7c24f222a11d112034b8a5e95f01feb4b610022c63bdc85d1ae2fe6abbd712e1"
    sha256 cellar: :any,                 arm64_sequoia:  "8ad9f1c15a4bc9c05a9dd184b53b8f5f5d13a2458a70535bfb01e54ce4f8b4bd"
    sha256 cellar: :any,                 arm64_sonoma:   "e5f86790b92dc68b3e1770cffb14dcfa42ed8cb2496b1ae9fb30c2d8ae66c037"
    sha256 cellar: :any,                 arm64_ventura:  "0f9a24bce721238c9f6fffaf6c490bb82e24fa0171bd23c66002d96ee67381e8"
    sha256 cellar: :any,                 arm64_monterey: "8f390bc5ee1fffa1191df48e2947acafd5063abdc713c595760f3ac6a7a8ebd6"
    sha256 cellar: :any,                 arm64_big_sur:  "3daf7c4d5a1b948b2564de026336e3f3496f693ea0743e42b50f78d09ee32469"
    sha256 cellar: :any,                 sonoma:         "7e89c242dfe4a49421d45416ac28e5b00c9b434664e81fcafb0a192a6f83076e"
    sha256 cellar: :any,                 ventura:        "ef762c7cd5d48df14a6455e7302cf9ff4fcb64e625ecaa779c4dee8b71e346ae"
    sha256 cellar: :any,                 monterey:       "69daed6f99f96edb350f06043d5d7121bb0d3eaa88e64ef5bac247f300d552e9"
    sha256 cellar: :any,                 big_sur:        "f67d3a167142d0afa6ef446260075a7e1c29cf3d1246a95bac2f12732004398a"
    sha256 cellar: :any,                 catalina:       "9b0934f5a868dc0c3874ae6491d685cff6537923cc49d6abea18c1bf59cddaea"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "abab20444fd53b2503b0f48172fe84c6503cd6219d00a83b63af96e60d395557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01048cd3e5c934f5fb7b7cd11430833c69022a621fcc2d868159e07bbef1e3e4"
  end

  depends_on "pkgconf" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
  end

  def install
    system "./configure", "--enable-mac-universal=no",
                          "--enable-cxx",
                          *std_configure_args
    system "make", "install"

    # Need 'pa_mac_core.h' to compile PyAudio
    include.install "include/pa_mac_core.h" if OS.mac?
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "portaudio.h"

      int main() {
        printf("%s",Pa_GetVersionInfo()->versionText);
      }
    C

    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include "portaudiocpp/System.hxx"

      int main() {
        std::cout << portaudio::System::versionText();
      }
    CPP

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lportaudio", "-o", "test"
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lportaudiocpp", "-o", "test_cpp"
    assert_match stable.version.to_s, shell_output("./test")
    assert_match stable.version.to_s, shell_output("./test_cpp")
  end
end
