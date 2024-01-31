class Ol < Formula
  desc "Purely functional dialect of Lisp"
  homepage "https://yuriy-chumak.github.io/ol/"
  url "https://github.com/yuriy-chumak/ol/archive/refs/tags/2.5.1.tar.gz"
  sha256 "d9fe66bd15cf9c9c30bf45b97e5825c2101b518fc27c671c08a95798eec3c510"
  license any_of: ["LGPL-3.0-or-later", "MIT"]
  head "https://github.com/yuriy-chumak/ol.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "0a2b9ab3ac2e7726505a1f3ecdc77d13943b175397ac7843786a652ef30c7f4b"
    sha256 arm64_ventura:  "22c54a4f86b32f8d2e8bfec6549260314789012bfc7efce1ce8a38d342db5534"
    sha256 arm64_monterey: "5910951a48547517b60d0e56cc911e42cf3b42d20a7a0557de48de64684ceab9"
    sha256 sonoma:         "6e043eaeaec93006cc30f224ef67ab48429b3a4e1a70e213ccaed7a7d8f17430"
    sha256 ventura:        "5640dae5de435477e613c4ab7cb4ec74e7502c9b82b6651f87b752835100fff8"
    sha256 monterey:       "856ec1ef735ee7706306e1c284a9e9adcb899dd1fd0b2c1c8a55adc998896ec0"
    sha256 x86_64_linux:   "77e2bb88642b3f7ecfe488fac9eb2224bbeffde3b6940cc373c4866846d91342"
  end

  uses_from_macos "vim" => :build # for xxd

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"gcd.ol").write <<~EOS
      (print (gcd 1071 1029))
    EOS
    assert_equal "21", shell_output("#{bin}/ol gcd.ol").strip
  end
end
