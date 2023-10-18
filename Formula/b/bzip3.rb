class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.3.2/bzip3-1.3.2.tar.gz"
  sha256 "152cf2134fc27b68fef37d72b8c1f9f327ac611f6101d5a01287cdba24bc58c3"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f7888c2995a326738ce5c4c64d8b1a474f91a51eb142766944d38650eb8e9411"
    sha256 cellar: :any,                 arm64_ventura:  "2ea8b7e5c22220aa1a619d8965980f9de2e1797db4a5661b5e02e72aaa79b3f8"
    sha256 cellar: :any,                 arm64_monterey: "d3385e01ee63a9276ff6e97d45dc915302975033200e2b8982c4e9ecae86c925"
    sha256 cellar: :any,                 arm64_big_sur:  "97823e4f334ac360abe4d586082bd41e849d12456a289e726b8c3dee67ab31ba"
    sha256 cellar: :any,                 sonoma:         "1a648a430becbe99e2eea26cd84f53ac8a4a21681698ff8c8c248dfeb0c481cd"
    sha256 cellar: :any,                 ventura:        "3def923fa3d96d2572e06f14955c27ed0ee01be0feaca282d2a419247c54156e"
    sha256 cellar: :any,                 monterey:       "eaf38150ede60fa2b1a05e940721398bc8cbd21505c1731986b826472ceef9a6"
    sha256 cellar: :any,                 big_sur:        "91948d9ac97c90b0fb18c690f14fe19eb26dfa7dc61e0bdb4b3e04870e2dfc9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69c297b108a2e38a65ff2e96595800e8c5a64209c1f071dd62f1153e6b0d4a52"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-arch-native"
    system "make", "install"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz3"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip3", testfilepath
    system bin/"bunzip3", "-f", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
