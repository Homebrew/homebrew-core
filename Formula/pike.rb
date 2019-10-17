class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.702.tar.gz"
  sha256 "c47aad2e4f2c501c0eeea5f32a50385b46bda444f922a387a5c7754302f12a16"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f299725be9679d3be3abcb580dc81c6512ae66e1a1a3b2034e329212899cfcff" => :catalina
    sha256 "f588f3ad79e59c90e7339fba213f67102b7040bb42fad2437ec4d3094e636295" => :mojave
    sha256 "5d67e09c9bb49b77a1a670591d6d2c1f8f039efe4b2b18c50e0f8941c072e976" => :high_sierra
  end

  depends_on "gmp"
  depends_on "libtiff"
  depends_on "nettle"
  depends_on "pcre"

  def install
    ENV.append "CFLAGS", "-m64"
    ENV.deparallelize

    system "make", "CONFIGUREARGS='--prefix=#{prefix} --without-bundles --with-abi=64'"

    system "make", "install",
                   "prefix=#{libexec}",
                   "exec_prefix=#{libexec}",
                   "share_prefix=#{libexec}/share",
                   "lib_prefix=#{libexec}/lib",
                   "man_prefix=#{libexec}/man",
                   "include_path=#{libexec}/include",
                   "INSTALLARGS=--traditional"

    bin.install_symlink "#{libexec}/bin/pike"
    share.install_symlink "#{libexec}/share/man"
  end

  test do
    path = testpath/"test.pike"
    path.write <<~EOS
      int main() {
        for (int i=0; i<10; i++) { write("%d", i); }
        return 0;
      }
    EOS

    assert_equal "0123456789", shell_output("#{bin}/pike #{path}").strip
  end
end
