class Espeak < Formula
  desc "Text to speech, software speech synthesizer"
  homepage "https://espeak.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/espeak/espeak/espeak-1.48/espeak-1.48.04-source.zip"
  sha256 "bf9a17673adffcc28ff7ea18764f06136547e97bbd9edf2ec612f09b207f0659"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/espeak[._-]v?(\d+(?:\.\d+)+)(?:-source)?\.(?:t|zip)}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "d2ded3f1dd697a128defd54554a3ebee69a2ed566734449b755fbf649a76e885"
    sha256 arm64_monterey: "03f0966e004a09d71f4607a458cd168a5b055eb110487158f723f602eb20e91b"
    sha256 arm64_big_sur:  "0bd59ad014f2deeb623f5128f44e48a06f34106e3c46d228452595e44b6cdf17"
    sha256 ventura:        "5e9fbcc6b6987dd44fd14bfb5e6ff7e4a39ad42c3b5f18b4625c0352f97a12e5"
    sha256 monterey:       "aae3368a900e67099b2f4916af1266cbadae620c129f5cc2aeee959342e213ca"
    sha256 big_sur:        "c8d5f5fd950e7f47f48affb043ba950694c6480d7a12231eb1f2606ab4e05dbe"
    sha256 catalina:       "9e3a743f118a7ca9d177d005d260814d576fc9c72f5cad369204a8c42c54ffb4"
    sha256 mojave:         "055c918c267f825ed18f089c75db7c7408ea25ca93ba1a99e0aaba6f5b3a446d"
    sha256 high_sierra:    "ff4334be449510bdea51a7d853890fec167914658eb4c5167c5a6b40c6621ee2"
    sha256 sierra:         "ad40b912f2b0cf1b72ab89d53729cd61717a9d9b5bc588950cd6318b63c9e133"
    sha256 el_capitan:     "5e2829905c793de0ccf38ccca04e03bc504f7f70137952d44177461c16cbf174"
    sha256 x86_64_linux:   "cd49a93ccf04b77d8bf926c77cb322615c25ef27d2b01cd8c08e45945bd01183"
  end

  depends_on "portaudio"

  def install
    share.install "espeak-data"
    doc.install Dir["docs/*"]
    cd "src" do
      rm "portaudio.h"
      if OS.mac?
        # macOS does not use -soname so replacing with -install_name to compile for macOS.
        # See https://stackoverflow.com/questions/4580789/ld-unknown-option-soname-on-os-x/32280483#32280483
        inreplace "Makefile", "SONAME_OPT=-Wl,-soname,", "SONAME_OPT=-Wl,-install_name,"
        # macOS does not provide sem_timedwait() so disabling #define USE_ASYNC to compile for macOS.
        # See https://sourceforge.net/p/espeak/discussion/538922/thread/0d957467/#407d
        inreplace "speech.h", "#define USE_ASYNC", "//#define USE_ASYNC"
      end

      system "make", "speak", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      bin.install "speak" => "espeak"
      system "make", "libespeak.a", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      lib.install "libespeak.a"
      system "make", "libespeak.so", "DATADIR=#{share}/espeak-data", "PREFIX=#{prefix}"
      # macOS does not use the convention libraryname.so.X.Y.Z. macOS uses the convention libraryname.X.dylib
      # See https://stackoverflow.com/questions/4580789/ld-unknown-option-soname-on-os-x/32280483#32280483
      libespeak = shared_library("libespeak", "1.#{version.major_minor}")
      lib.install "libespeak.so.1.#{version.major_minor}" => libespeak
      lib.install_symlink libespeak => shared_library("libespeak", 1)
      lib.install_symlink libespeak => shared_library("libespeak")
      MachO::Tools.change_dylib_id("#{lib}/libespeak.dylib", "#{lib}/libespeak.dylib") if OS.mac?
    end
  end

  test do
    system "#{bin}/espeak", "This is a test for Espeak.", "-w", "out.wav"
  end
end
