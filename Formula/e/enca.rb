class Enca < Formula
  desc "Charset analyzer and converter"
  homepage "https://cihar.com/software/enca/"
  url "https://dl.cihar.com/enca/enca-1.19.tar.gz"
  sha256 "4c305cc59f3e57f2cfc150a6ac511690f43633595760e1cb266bf23362d72f8a"
  license "GPL-2.0-only"
  head "https://github.com/nijel/enca.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?enca[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "4d3a21ddb033608bec30faf735d28d3f16f94f557394b495a638136957d77da4"
    sha256 arm64_sequoia:  "39e220bf0bc73df65cfbc2b9702a29ed48197a9c721760111cc4af07f771a912"
    sha256 arm64_sonoma:   "2528d77eb23d82075f2cb1d877ea170927c4bb16a38f1a05fa1494545973ef23"
    sha256 arm64_ventura:  "e15cd4000e00b96652d900fdce002e2180eed2fe09662ad0359fd176a4e1e3ce"
    sha256 arm64_monterey: "305c3af3a704843192d4ed0bf9e75df33742d186ba3bcfec4273ced362dab5da"
    sha256 arm64_big_sur:  "bb6dbdce00c0f724d1c6bbb8afdf057e857851dac9d7ced14f61504382ce6ee0"
    sha256 sonoma:         "3cb0516182d1dd6a088df1ea64dc194c0b37c795cd71e169a0e1bcb07eb4c484"
    sha256 ventura:        "d71371be8f80e3c61e5a53cd3fc8624d65b58f79cb27f72de95ea16ecf959b22"
    sha256 monterey:       "e30444291139db29c1c1cde042bfef31578923c9133eeb96f3780af14c4fc55e"
    sha256 big_sur:        "6c16034f0a17fdcc4c5ca8c1f280da2138213958f3ea7aac007ad8a54e063a76"
    sha256 catalina:       "606385c50e1a4aae697fc9b6d48023013d1943929ede359b830fd7db42641bcf"
    sha256 arm64_linux:    "40416a7bc0c169fc9148dafe33b935c75f18b1bf6d41980a03d1d12d7df18007"
    sha256 x86_64_linux:   "c434ad486d2bc894f2562f7a02257bfa726a8623287e5f665cc4d20f7ea42c25"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
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
