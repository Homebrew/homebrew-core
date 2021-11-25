class Enca < Formula
  desc "Charset analyzer and converter"
  homepage "https://cihar.com/software/enca/"
  url "https://dl.cihar.com/enca/enca-1.19.tar.gz"
  sha256 "4c305cc59f3e57f2cfc150a6ac511690f43633595760e1cb266bf23362d72f8a"
  license "GPL-2.0-only"
  head "https://github.com/nijel/enca.git"

  livecheck do
    url :homepage
    regex(/href=.*?enca[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "305c3af3a704843192d4ed0bf9e75df33742d186ba3bcfec4273ced362dab5da"
    sha256 arm64_big_sur:  "bb6dbdce00c0f724d1c6bbb8afdf057e857851dac9d7ced14f61504382ce6ee0"
    sha256 monterey:       "e30444291139db29c1c1cde042bfef31578923c9133eeb96f3780af14c4fc55e"
    sha256 big_sur:        "6c16034f0a17fdcc4c5ca8c1f280da2138213958f3ea7aac007ad8a54e063a76"
    sha256 catalina:       "606385c50e1a4aae697fc9b6d48023013d1943929ede359b830fd7db42641bcf"
    sha256 mojave:         "6a9d4f53371b7ffd66f37f290a24b52c2014433d254f0856de68c99fbd8c6f1c"
    sha256 high_sierra:    "5cfee364a5cc91d945d331d980448745d8498703d6b30378bd11be541c5be51d"
    sha256 sierra:         "0920a4dd92de3f4d7725e6753a37d1cb5f2468063f4020def9167648ff21e046"
    sha256 el_capitan:     "889b9d13ff462aee05bb0afdbe012f6a388a2b5e30e13b55954f94a18db69a13"
    sha256 yosemite:       "c7e41db5725d169800674add5dfc3ab82d888f55f6703e44cda109348ed509e7"
    sha256 x86_64_linux:   "c434ad486d2bc894f2562f7a02257bfa726a8623287e5f665cc4d20f7ea42c25"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    enca = "#{bin}/enca --language=none"
    assert_match "ASCII", pipe_output(enca, "Testing...")
    ucs2_text = pipe_output("#{enca} --convert-to=UTF-16", "Testing...")
    assert_match "UCS-2", pipe_output(enca, ucs2_text)
  end
end
