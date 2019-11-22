class Enca < Formula
  desc "Charset analyzer and converter"
  homepage "https://cihar.com/software/enca/"
  url "https://dl.cihar.com/enca/enca-1.19.tar.gz"
  sha256 "4c305cc59f3e57f2cfc150a6ac511690f43633595760e1cb266bf23362d72f8a"
  head "https://github.com/nijel/enca.git"

  bottle do
    sha256 "606385c50e1a4aae697fc9b6d48023013d1943929ede359b830fd7db42641bcf" => :catalina
    sha256 "6a9d4f53371b7ffd66f37f290a24b52c2014433d254f0856de68c99fbd8c6f1c" => :mojave
    sha256 "5cfee364a5cc91d945d331d980448745d8498703d6b30378bd11be541c5be51d" => :high_sierra
    sha256 "0920a4dd92de3f4d7725e6753a37d1cb5f2468063f4020def9167648ff21e046" => :sierra
    sha256 "889b9d13ff462aee05bb0afdbe012f6a388a2b5e30e13b55954f94a18db69a13" => :el_capitan
    sha256 "c7e41db5725d169800674add5dfc3ab82d888f55f6703e44cda109348ed509e7" => :yosemite
    sha256 "9dcf7437c2ccedd4a7e10b167ba37c184a0e3aed08714af382f85771196cb0bb" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    enca = "#{bin}/enca --language=none"
    assert_match /ASCII/, `#{enca} <<< 'Testing...'`
    assert_match /UCS-2/, `#{enca} --convert-to=UTF-16 <<< 'Testing...' | #{enca}`
  end
end
