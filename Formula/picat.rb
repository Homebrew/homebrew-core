class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat25_src.tar.gz"
  version "2.5"
  sha256 "143cf2b0823d7fa78830339ab800876d277bae18834349f484f2bdd4e3b7213f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a1211162f9dc2e87211ac452d8451a3f7e75dbc7b4312463ed0caa82ccaa55c" => :mojave
    sha256 "acbaf9e2dd1fb8b707213271a41eac2a33e2a0247f8ee3187a81f72fafdfc807" => :high_sierra
    sha256 "15adabe5e7cb8c19cea32893da7f56d192503307458b6c8ed145e7cf6da8fa9d" => :sierra
    sha256 "95985a5a22784c13dba594b1b3e6433c7705def3712cd97a7da99c4ce30bfd20" => :el_capitan
  end

  def install
    # Hardcode in Makefile issue is reported to upstream in the official Google Groups
    # https://groups.google.com/d/msg/picat-lang/0kZYUJKgnkY/3Vig5X1NCAAJ
    inreplace "emu/Makefile.picat.mac64", "/usr/local/bin/gcc", "gcc"
    system "make", "-C", "emu", "-f", "Makefile.picat.mac64"

    bin.install "emu/picat_macx" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end
