class Aften < Formula
  desc "Audio encoder which generates ATSC A/52 compressed audio streams"
  homepage "https://aften.sourceforge.net/"
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "98174738f94e5b13f3814dca23e803878017f9d719e0eb7d5f3ebb82e7819db7"
    sha256 cellar: :any,                 arm64_sequoia:  "c158dd1b9124db377e0119b6d4dc34ce9ecb14e458379ab023165ce6b83715fb"
    sha256 cellar: :any,                 arm64_sonoma:   "918b76d55d51e34cd63b83041517d0a06dd9b10f24a2d35ec8b68fc97a04f589"
    sha256 cellar: :any,                 arm64_ventura:  "b210014aa83271ec35261c51fc2d32914b33090deb3fda59993e30aba4b324de"
    sha256 cellar: :any,                 arm64_monterey: "a1a669de1fd73431993f57c52603cb68d5794590bb175084de3ffac408d50c13"
    sha256 cellar: :any,                 arm64_big_sur:  "6f4cfa96fbcc6616017d696852e0738796471c24b2bcbd4ee38ce9cd2c01575c"
    sha256 cellar: :any,                 sonoma:         "05e65496042ea60735223e9cfa06b97ee8ae136531aafe8d7550f40051ecc33e"
    sha256 cellar: :any,                 ventura:        "0ac6b5c31292bc1fea37415cf9f76010633c6c4a2bf3cc8770c4f9cd3b79cbbb"
    sha256 cellar: :any,                 monterey:       "f4632d08d823d8bda73e319dd6bf3f27651c9df4a61a2e0bfec30a116ed8745f"
    sha256 cellar: :any,                 big_sur:        "86e6506319cdf2eb030d2084663acbabd75dc3ce5f3a6e60fbd9af27c60bad1b"
    sha256 cellar: :any,                 catalina:       "c1f3497bae95d7cd92f28b1a22d2dcfc06c0c7342c6c2993b6f564110f6e8f99"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "30a63d92db554df38e376c97fd0052b6b01956f89f3bb0b9f81309b11df8a332"
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
    # Fix build with CMake 4.0+.
    inreplace "CMakeLists.txt",
              "CMAKE_MINIMUM_REQUIRED(VERSION 2.4)",
              "CMAKE_MINIMUM_REQUIRED(VERSION 3.10)"

    mkdir "default" do
      system "cmake", "-DSHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("sample_wav").stage testpath
    system bin/"aften", "#{testpath}/1kHz_44100Hz_16bit_05sec.wav", "sample.ac3"
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
