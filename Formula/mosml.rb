class Mosml < Formula
  desc "Moscow ML"
  homepage "http://mosml.org"
  url "https://github.com/kfl/mosml/archive/ver-2.10.1.tar.gz"
  sha256 "fed5393668b88d69475b070999b1fd34e902591345de7f09b236824b92e4a78f"

  bottle do
    sha256 "297c05c55f2784f3b934a2fdb3ec2f91d8b11a06453c8649c1f6562cefdc089e" => :sierra
    sha256 "5dae62ca2034ba70844d684111cec58561895eac39db3177d439747512206002" => :el_capitan
    sha256 "3a0289ba1b1a56cf3c2a598ccbee9b1739c7c35628a173dd00bd2f20fead6703" => :yosemite
    sha256 "97ba76cf36e165dc798bdae33fc06c7c5954b1293686f43d2781b3130e75a119" => :mavericks
    sha256 "846e6c0980ebd5fd968425b51bfa25718feb66c5ff88aaeec7928d7186fb85cf" => :mountain_lion
  end

  depends_on "gmp"

  def install
    cd "src" do
      system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "world"
      system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "install"
    end
  end

  test do
    system "#{bin}/mosml", "-P full"
  end
end
