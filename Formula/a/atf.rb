class Atf < Formula
  desc "Automated testing framework"
  homepage "https://github.com/jmmv/atf"
  url "https://github.com/jmmv/atf/releases/download/atf-0.21/atf-0.21.tar.gz"
  sha256 "92bc64180135eea8fe84c91c9f894e678767764f6dbc8482021d4dde09857505"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_ventura:  "a450d3062f887473809527c9e45451941476c4b22d5f0803bc261dafc5986168"
    sha256 arm64_monterey: "650c374c9509cd3634ef36fd0d61bd7c852536778be5ffa2c0c9b4590fc92d66"
    sha256 arm64_big_sur:  "67cc581f8b6a72d2ebe4a5d9210ff0b39c247f76852afa50df699988c3617783"
    sha256 ventura:        "d6c554da757f3069d0bc49db0e9beb981c38255016ed3685fed2ac593a10e02f"
    sha256 monterey:       "4c9f336e433ec164c422e391de58eb6a68539b58463e0bc8eeefc151dd8767c2"
    sha256 big_sur:        "fff75eabcd7eb2a52aca286d42f82f4488b5a28fc2c7dc154fd0b34d62366272"
    sha256 catalina:       "39570850845a8c01f2ce167fec23284fc6172c816a9d5806b9c9034448d5a0a3"
    sha256 mojave:         "c8e2c7b3d06d8c84409ef21b12201803113244d668eb092decf073fc5066fdab"
    sha256 high_sierra:    "034a9f29ce63bd5cd019b957bc544a3129df7ec3872453f57f24914dce1f2da8"
    sha256 sierra:         "a58333135e72fa1817c0411f3801615780c4346347d73d25ddec6eca6b213c41"
    sha256 el_capitan:     "74493d4b4868628a7a84338eb28ecfce8afdd896962f3ba632b1e785def48737"
    sha256 x86_64_linux:   "c9a94b838e115887902fd1e12ef77cce606f475772668278908382fb161d1ca6"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/890be5f6af88e7913d177af87a50129049e681bb/libtool/configure-pre-0.4.3-big_sur.diff"
    sha256 "58557ebff9e6b8e9b9b71dc6c5820ad3e0c550a385d4126c6078caa2b72e63c1"
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
