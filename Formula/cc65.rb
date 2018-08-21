class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "https://github.com/cc65/cc65/archive/V2.17.tar.gz"
  sha256 "73b89634655bfc6cef9aa0b8950f19657a902ee5ef0c045886e418bb116d2eac"
  head "https://github.com/cc65/cc65.git"

  bottle do
    sha256 "d8238bad77a894edec5e5caefd7ae6c738177a04455024a7c2cb3d44db3a4d85" => :mojave
    sha256 "12c9533c600dda022dc121f51f668648cd89a98e407e02aeb2119c21d8e8cc54" => :high_sierra
    sha256 "f470bfeec0cc01b3da7656945e401815a852f2d6fbca5197f9dd41dc3391a539" => :sierra
    sha256 "46e8dc043981d55e0b62e77cd12dae35b1ab13b3164f1510010e73bbe8ee76a9" => :el_capitan
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
