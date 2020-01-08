class Cc65 < Formula
  desc "6502 C compiler"
  homepage "https://cc65.github.io/cc65/"
  url "https://github.com/cc65/cc65/archive/V2.18.tar.gz"
  sha256 "d14a22fb87c7bcbecd8a83d5362d5d317b19c6ce2433421f2512f28293a6eaab"
  head "https://github.com/cc65/cc65.git"

  bottle do
    sha256 "8f64703adec128eede5e3a980d1898e2b13ed87441ef7fdb5d41400850b82989" => :catalina
    sha256 "a84e72ecee825a41a9614a7563df24418d5173ff13ff767adf2a924e28b00fcb" => :mojave
    sha256 "2fecec53d0f65fc2ae409fc29516207cf11377e6726574087da4f06502e10770" => :high_sierra
    sha256 "e4bf2981ea6489e414bf2166f6e591612b2e589aa30a3beaab1fd0d7a2ca1207" => :sierra
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
