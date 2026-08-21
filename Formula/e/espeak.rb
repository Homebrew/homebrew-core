class Espeak < Formula
  desc "Text to speech, software speech synthesizer"
  homepage "https://espeak.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/espeak/espeak/espeak-1.48/espeak-1.48.04-source.zip"
  sha256 "bf9a17673adffcc28ff7ea18764f06136547e97bbd9edf2ec612f09b207f0659"
  license all_of: ["GPL-3.0-or-later", "LGPL-2.1-or-later"]
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/espeak[._-]v?(\d+(?:\.\d+)+)(?:-source)?\.(?:t|zip)}i)
  end

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "79fcbb8b62d46c59ae01252339039e5370c4b9c267a4239466c14cf351521685"
    sha256 arm64_sequoia: "ac1da3a5f93deb24bce3a169193104a8d57b6e7d25ba5b757d381b7bdcdae8b0"
    sha256 arm64_sonoma:  "8b43605a396132f440a9f40b776d909a3b0371bc33efb59c054df4a5e2345c8a"
    sha256 sonoma:        "e1db33fd0da749daa8c099e6cec84781fceb7815306813386c5d4b92c6acf4a8"
    sha256 arm64_linux:   "8dc1f69d9bdb22493f5aaf487d58126ddcda76ad701c05572ae1a58a61445c82"
    sha256 x86_64_linux:  "3f19dd3507512ae024acb0f24ccf18a704ff9c3426d2f114f456f658fd44bd56"
  end

  # SourceForge page (https://sourceforge.net/projects/espeak/) says:
  # "As of 2021-11-17, this project can be found here." and links to `espeak-ng`.
  deprecate! date: "2025-11-13", because: :unmaintained, replacement_formula: "espeak-ng"
  disable! date: "2026-11-13", because: :unmaintained, replacement_formula: "espeak-ng"

  depends_on "portaudio"

  conflicts_with "espeak-ng", because: "both install `espeak` binaries"

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

      cxxflags = []
      # Workaround for newer Clang
      cxxflags << "-Wno-c++11-narrowing" if DevelopmentTools.clang_build_version >= 1403

      make_args = %W[
        DATADIR=#{share}/espeak-data
        PREFIX=#{prefix}
        CXXFLAGS=#{cxxflags.join(" ")}
      ]
      system "make", "speak", *make_args
      bin.install "speak" => "espeak"
      system "make", "libespeak.a", *make_args
      lib.install "libespeak.a"
      system "make", "libespeak.so", *make_args
      # macOS does not use the convention libraryname.so.X.Y.Z. macOS uses the convention libraryname.X.dylib
      # See https://stackoverflow.com/questions/4580789/ld-unknown-option-soname-on-os-x/32280483#32280483
      libespeak = shared_library("libespeak", "1.#{version.major_minor}")
      lib.install "libespeak.so.1.#{version.major_minor}" => libespeak
      lib.install_symlink libespeak => shared_library("libespeak", 1)
      lib.install_symlink libespeak => shared_library("libespeak")
      change_dylib_id lib/"libespeak.dylib", lib/"libespeak.dylib", resolve_source: true if OS.mac?
    end
  end

  test do
    system bin/"espeak", "This is a test for Espeak.", "-w", "out.wav"
  end
end
