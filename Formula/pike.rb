class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.702.tar.gz"
  sha256 "c47aad2e4f2c501c0eeea5f32a50385b46bda444f922a387a5c7754302f12a16"
  revision 1

  bottle do
    cellar :any
    sha256 "ae20ba3c7fd69c026892555798559bd2da90d53dc3cf07eb5d7423af505082d5" => :catalina
    sha256 "ff1e2f11d0beec51cc41d9eb566a80cbf53b51933158c6083054e3b91dfa251c" => :mojave
    sha256 "10eb373d72d3c178dc1f560a7e1c35f8b6dc51412d7eb4f4cf4f751109d4fd9d" => :high_sierra
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
