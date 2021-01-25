class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.702.tar.gz"
  # Homepage has an expired SSL cert as of 16/12/2020, so we add a Debian mirror
  mirror "http://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0_8.0.702.orig.tar.gz"
  sha256 "c47aad2e4f2c501c0eeea5f32a50385b46bda444f922a387a5c7754302f12a16"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "MPL-1.1"]
  revision 4

  livecheck do
    url "https://pike.lysator.liu.se/download/pub/pike/latest-stable/"
    regex(/href=.*?Pike[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "5aa4cacc8d0fd3d81fca3e029a74813f3c40b2a8d27684b9ee665aece4b50f45" => :big_sur
    sha256 "0e1de33bfc595a2a4b944b496aa886ab620554fbea24bbf080cef9403b8fc24f" => :arm64_big_sur
    sha256 "65526e58ded68ff16a6eb53104406f48ac535ac955912b320c724b497d418619" => :catalina
    sha256 "550251a57aacd9f491cfda25c997a544bd993dcd1c9b1d29f03e7386bf16c758" => :mojave
  end

  depends_on "gmp"
  depends_on "libtiff"
  depends_on "nettle"
  depends_on "pcre"

  on_linux do
    depends_on "jpeg"
  end

  def install
    ENV.append "CFLAGS", "-m64"
    ENV.deparallelize

    # Workaround for https://git.lysator.liu.se/pikelang/pike/-/issues/10058
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

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
