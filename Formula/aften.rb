class Aften < Formula
  desc "Audio encoder which generates ATSC A/52 compressed audio streams"
  homepage "https://aften.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/aften/aften/0.0.8/aften-0.0.8.tar.bz2"
  sha256 "87cc847233bb92fbd5bed49e2cdd6932bb58504aeaefbfd20ecfbeb9532f0c0a"
  license "LGPL-2.1-or-later"

  # Aften has moved from a version scheme like 0.07 to 0.0.8. We restrict
  # matching to versions with three parts, since a version like 0.07 is parsed
  # as 0.7 and seen as newer than 0.0.8.
  livecheck do
    url :stable
    regex(%r{url=.*?/aften[._-]v?(\d+(?:\.\d+){2,})\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a1a669de1fd73431993f57c52603cb68d5794590bb175084de3ffac408d50c13"
    sha256 cellar: :any,                 arm64_big_sur:  "6f4cfa96fbcc6616017d696852e0738796471c24b2bcbd4ee38ce9cd2c01575c"
    sha256 cellar: :any,                 monterey:       "f4632d08d823d8bda73e319dd6bf3f27651c9df4a61a2e0bfec30a116ed8745f"
    sha256 cellar: :any,                 big_sur:        "86e6506319cdf2eb030d2084663acbabd75dc3ce5f3a6e60fbd9af27c60bad1b"
    sha256 cellar: :any,                 catalina:       "c1f3497bae95d7cd92f28b1a22d2dcfc06c0c7342c6c2993b6f564110f6e8f99"
    sha256 cellar: :any,                 mojave:         "07e80303cd84483b9e86b880feb3885814644b115f161ad10582c6ce99cf192d"
    sha256 cellar: :any,                 high_sierra:    "b1b8facf243da3872f4ddf2fbefb4879228cb5b390f883794b8b115d06e4c6a6"
    sha256 cellar: :any,                 sierra:         "535ef47b08163c8d1d7a66ffda7d3f280c0569a74d9feedbcfc93cd3c55194ca"
    sha256 cellar: :any,                 el_capitan:     "68b4983cc843e2d57854a263038a965a2dd6c473c98111f482ec1c69d09ace83"
    sha256 cellar: :any,                 yosemite:       "4f785f04a3bbde677452f2c5d1c04f77605e156b4020294c5799c85d0b8586d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9e42d32fbd1c37b67e5beb729fba09eed1378d0f44c89b0b313231d478320d7"
  end

  depends_on "cmake" => :build

  resource "sample_wav" do
    url "https://www.mediacollege.com/audio/tone/files/1kHz_44100Hz_16bit_05sec.wav"
    sha256 "949dd8ef74db1793ac6174b8d38b1c8e4c4e10fb3ffe7a15b4941fa0f1fbdc20"
  end

  # The ToT actually compiles fine, but there's no official release made from that changeset.
  # So fix the Apple Silicon compile issues.
  patch :DATA

  def install
    mkdir "default" do
      system "cmake", "-DSHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("sample_wav").stage testpath
    system "#{bin}/aften", "#{testpath}/1kHz_44100Hz_16bit_05sec.wav", "sample.ac3"
  end
end
__END__
From dca9c03930d669233258c114e914a01f7c0aeb05 Mon Sep 17 00:00:00 2001
From: jbr79 <jbr79@ef0d8562-5c19-0410-972e-841db63a069c>
Date: Wed, 24 Sep 2008 22:02:59 +0000
Subject: [PATCH] add fallback function for apply_simd_restrictions() on
 non-x86/ppc

git-svn-id: https://aften.svn.sourceforge.net/svnroot/aften@766 ef0d8562-5c19-0410-972e-841db63a069c
---
 libaften/cpu_caps.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libaften/cpu_caps.h b/libaften/cpu_caps.h
index b7c6159..4db11f7 100644
--- a/libaften/cpu_caps.h
+++ b/libaften/cpu_caps.h
@@ -26,6 +26,7 @@
 #include "ppc_cpu_caps.h"
 #else
 static inline void cpu_caps_detect(void){}
+static inline void apply_simd_restrictions(AftenSimdInstructions *simd_instructions){}
 #endif

 #endif /* CPU_CAPS_H */
--
2.24.3 (Apple Git-128)
