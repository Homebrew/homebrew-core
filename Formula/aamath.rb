class Aamath < Formula
  desc "Renders mathematical expressions as ASCII art"
  homepage "http://fuse.superglue.se/aamath/"
  url "http://fuse.superglue.se/aamath/aamath-0.3.tar.gz"
  sha256 "9843f4588695e2cd55ce5d8f58921d4f255e0e65ed9569e1dcddf3f68f77b631"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ac1413ef0322b280ae5bd5663373ed959ee54d28dbdd3261fc4da6e57abf44c" => :catalina
    sha256 "79ef03b1d334136b693131b133944109545b07aca2dfd9165531016e4250444c" => :mojave
    sha256 "41223cb51bc006abfba33b6af77b665c28de4155d19e5f43d0561b885b73368f" => :high_sierra
    sha256 "d537cb11d2dcbac9b5d5356c471775699312e83450635ba7676083f381a531cd" => :sierra
    sha256 "8b805e37fd5f4536b4fbf7f3ae6251b645b4b132027d56ccd015a6036c304744" => :el_capitan
    sha256 "1e22022e621e7d2337edf4a80ae2c1618a89089132656d85cc141774565e34d7" => :yosemite
    sha256 "0212e0b5844ea1a491bc7d4fcab2b590921042b28bc50e79c36cd9e15d08e2aa" => :mavericks
  end

  # Fix build on clang; patch by Homebrew team
  # https://github.com/Homebrew/homebrew/issues/23872
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/aamath/0.3.patch"
    sha256 "9443881d7950ac8d2da217a23ae3f2c936fbd6880f34dceba717f1246d8608f1"
  end

  def install
    ENV.deparallelize
    system "make"

    bin.install "aamath"
    man1.install "aamath.1"
    prefix.install "testcases"
  end

  test do
    s = pipe_output("#{bin}/aamath", (prefix/"testcases").read)
    assert_match /#{Regexp.escape("f(x + h) = f(x) + h f'(x)")}/, s
  end
end
