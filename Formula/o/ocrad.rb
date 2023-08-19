class Ocrad < Formula
  desc "Optical character recognition (OCR) program"
  homepage "https://www.gnu.org/software/ocrad/"
  url "https://ftp.gnu.org/gnu/ocrad/ocrad-0.28.tar.lz"
  mirror "https://ftpmirror.gnu.org/ocrad/ocrad-0.28.tar.lz"
  sha256 "34ccea576dbdadaa5979e6202344c3ff68737d829ca7b66f71c8497d36bbbf2e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01e67cda156e5752f29d8702f353a37c62a4e7e9712bb8aa63349ac75ce76489"
    sha256 cellar: :any,                 arm64_monterey: "443fa5aa2aba1104b638287c43df241736769328d32f234ec3af8da24bccc2ea"
    sha256 cellar: :any,                 arm64_big_sur:  "ca07488430da95c3c7c59fc8658a8009942ddd05ce4ebb5986b3530d95551366"
    sha256 cellar: :any,                 ventura:        "8bae7a6878fa7fa8d272a36e9320db3633b13067d617eddb448fc1b3a1e9f6c6"
    sha256 cellar: :any,                 monterey:       "ec671c1d8ea4e8fb12bc40fc502e1c462e9f6ffb320fd8d9fedc1698267a92e5"
    sha256 cellar: :any,                 big_sur:        "f942c1124e0e1061808f6981e0dd9ddbf2bed352e4f325a38a0514ffcd6f24d8"
    sha256 cellar: :any,                 catalina:       "5abeb11db2bc2f220afbc610ddbc59ca04352dd2318b6dfd8ae289e357b2661e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d8d1bdfa4d338a02ba6293b7527b81d3093a07dbbc9943461c4fe7c3291a3a1"
  end

  depends_on "libpng"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    (testpath/"test.pbm").write <<~EOS
      P1
      # This is an example bitmap of the letter "J"
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    assert_equal "J", `#{bin}/ocrad #{testpath}/test.pbm`.strip
  end
end
