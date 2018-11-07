class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.702.tar.gz"
  sha256 "c47aad2e4f2c501c0eeea5f32a50385b46bda444f922a387a5c7754302f12a16"

  bottle do
    sha256 "0985d750f7b4fe325483bcba5af44bfa93971c1660c27266b2597cabb77b2fdc" => :mojave
    sha256 "432a58be844ff2f0f9ed535264ee959ab905db0299b1b516915ccd97366b81ab" => :high_sierra
    sha256 "082ef34d2cbd6b9cb269be07f1ba8c29fe0121be59f17cf4ff71440a25af7ecc" => :sierra
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
