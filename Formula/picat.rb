class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat26_src.tar.gz"
  version "2.6"
  sha256 "922002ad200ce81fefdc562088b9dc308c9a3a131784c8b79246ebde0ab75642"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e0c2b2ad34996acb890fa31c5201649b2058d3995db0b2a986ef9bf187063ec" => :mojave
    sha256 "f7eee8a92769b4390921f37493407cd3f54c0e882b3d24056f21bdc660d59c3b" => :high_sierra
    sha256 "fac2cb3b92d58d01c522486024c6fc14f43d34ee10d9ea3c174f32e749236a6d" => :sierra
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
