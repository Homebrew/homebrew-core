class Atf < Formula
  desc "ATF: Automated Testing Framework"
  homepage "https://github.com/jmmv/atf"
  url "https://github.com/jmmv/atf/releases/download/atf-0.21/atf-0.21.tar.gz"
  sha256 "92bc64180135eea8fe84c91c9f894e678767764f6dbc8482021d4dde09857505"

  bottle do
    sha256 "c8e2c7b3d06d8c84409ef21b12201803113244d668eb092decf073fc5066fdab" => :mojave
    sha256 "034a9f29ce63bd5cd019b957bc544a3129df7ec3872453f57f24914dce1f2da8" => :high_sierra
    sha256 "a58333135e72fa1817c0411f3801615780c4346347d73d25ddec6eca6b213c41" => :sierra
    sha256 "74493d4b4868628a7a84338eb28ecfce8afdd896962f3ba632b1e785def48737" => :el_capitan
    sha256 "e4caa0498d0caf2e99e0eea9ae9269240e4f4a49a41f712cf6a730fab8d72672" => :yosemite
    sha256 "240443a1a96ba8ed51ac7b263749f69013f05d42eb84018824791e419a6d5e81" => :mavericks
    sha256 "be1a15d142717902889cf540f02641c34fd3241a369bf25f1c9c31197f04dccf" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/usr/bin/env atf-sh
      echo test
      exit 0
    EOS
    system "bash", "test.sh"
  end
end
