class Gpatch < Formula
  desc "Apply a diff file to an original"
  homepage "https://savannah.gnu.org/projects/patch/"
  url "https://ftp.gnu.org/gnu/patch/patch-2.7.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/patch/patch-2.7.7.tar.xz"
  sha256 "26175a5f099c3dea44b8e07c3f9ca0d014f9e36fba76280b01f92d98d02c2012"

  bottle do
    cellar :any_skip_relocation
    sha256 "f539f83039bc989b16aac11becfaa933c6dc8088f6fa060a8e01e84ed0a61d77" => :catalina
    sha256 "c25bf27bae741a7ec1a16d19d449d28b4b4a2f225190f55badf86b64b0266f4d" => :mojave
    sha256 "418d7ea9c3948a5d70bdca202bd56e5554eef7f105fc25449f041331db7f4f96" => :high_sierra
    sha256 "81e0fb63928b01d60b9d7a1f0bdbf262679888556bd055fd02f4f57a70cb87ad" => :sierra
    sha256 "bd67af8b9c24fa785a2da2a1d3475305593dbc183331aed657313e4066de3259" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testfile = testpath/"test"
    testfile.write "homebrew\n"
    patch = <<~EOS
      1c1
      < homebrew
      ---
      > hello
    EOS
    pipe_output("#{bin}/patch #{testfile}", patch)
    assert_equal "hello", testfile.read.chomp
  end
end
