class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "https://github.com/cc65/cc65/archive/V2.17.tar.gz"
  sha256 "73b89634655bfc6cef9aa0b8950f19657a902ee5ef0c045886e418bb116d2eac"
  head "https://github.com/cc65/cc65.git"

  bottle do
    sha256 "d0e95f0073a40ad6a7cf252c0a9ac3097fecdd7d1b8e132f3cb0314554c8e673" => :high_sierra
    sha256 "c3e1ba0c47aa7cff0841b4aba4688d8598fbc39733cc4da9cfebbb626330e222" => :sierra
    sha256 "f0c5fee3dab48fc030953717cdea847a1bd7fc040d50f34407330f190de54420" => :el_capitan
    sha256 "c7b91bec2fa66f33f2c1f87a12db927ca613652e9a0e2b52848f6cc06d00acbc" => :yosemite
  end

  conflicts_with "grc", :because => "both install `grc` binaries"

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      Library files have been installed to:
        #{pkgshare}
    EOS
  end

  test do
    (testpath/"foo.c").write "int main (void) { return 0; }"

    system bin/"cl65", "foo.c" # compile and link
    assert_predicate testpath/"foo", :exist? # binary
  end
end
