class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "https://github.com/cc65/cc65/archive/V2.16.tar.gz"
  sha256 "fdbbf1efbf2324658a5774fdceef4a1b202322a04f895688d95694843df76792"

  head "https://github.com/cc65/cc65.git"

  bottle do
    sha256 "c3e1ba0c47aa7cff0841b4aba4688d8598fbc39733cc4da9cfebbb626330e222" => :sierra
    sha256 "f0c5fee3dab48fc030953717cdea847a1bd7fc040d50f34407330f190de54420" => :el_capitan
    sha256 "c7b91bec2fa66f33f2c1f87a12db927ca613652e9a0e2b52848f6cc06d00acbc" => :yosemite
  end

  conflicts_with "grc", :because => "both install `grc` binaries"

  def install
    ENV.deparallelize

    make_vars = ["prefix=#{prefix}", "libdir=#{share}"]

    system "make", *make_vars
    system "make", "install", *make_vars
  end

  def caveats; <<-EOS.undent
    Library files have been installed to:
      #{pkgshare}
    EOS
  end

  test do
    (testpath/"foo.c").write "int main (void) { return 0; }"

    system bin/"cl65", "foo.c" # compile and link
    assert File.exist?("foo")  # binary
  end
end
