class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.702.tar.gz"
  sha256 "c47aad2e4f2c501c0eeea5f32a50385b46bda444f922a387a5c7754302f12a16"

  bottle do
    sha256 "2d5e507a73e731cb8fe9bd8cf38a55ed469e63abc48ca20b8b370a5f87b81ef7" => :mojave
    sha256 "61803c25145ee316b9883a94ebb7b6d96a14aa77e2d860b4025379943d8f27a3" => :high_sierra
    sha256 "0792ad6bbd3988b928e4ad8e91a0b189ef4f591c51f3af4b622d7ddff4039b1d" => :sierra
    sha256 "f23b16351cd5bed06c310c78b083caa6df91c21fbe386f6a2f73803404f01762" => :el_capitan
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
