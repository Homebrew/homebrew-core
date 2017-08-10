class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "https://github.com/cc65/cc65/archive/V2.16.tar.gz"
  sha256 "fdbbf1efbf2324658a5774fdceef4a1b202322a04f895688d95694843df76792"

  head "https://github.com/cc65/cc65.git"

  bottle do
    sha256 "991ea27c27b192abe257e46ac503583254539a6bb71e1394c069acb42cff0807" => :sierra
    sha256 "a8d0601368f3f6c4048c63e4f785d5159c0aab3f4e3a86c49a65cd3cdf69ae53" => :el_capitan
    sha256 "0320f31da62970bce189a3d6b8bdae5e595fa113eba7a37b5812e75dc6f89d72" => :yosemite
    sha256 "8f56a19db5bfa9d606e7f636c3780a7e29206e0f9b845365f91550f58e46d2b4" => :mavericks
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
