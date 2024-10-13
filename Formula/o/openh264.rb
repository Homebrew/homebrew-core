class Openh264 < Formula
  desc "H.264 codec from Cisco"
  homepage "https://www.openh264.org/"
  url "https://github.com/cisco/openh264/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "8ffbe944e74043d0d3fb53d4a2a14c94de71f58dbea6a06d0dc92369542958ea"
  license "BSD-2-Clause"
  head "https://github.com/cisco/openh264.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f96c9079b9bbcd3e86c651511443bfd84caf406a0bb7714859b531c9f35a4729"
    sha256 cellar: :any,                 arm64_sonoma:   "850e4e3d1c3a7344d860435f26801df7fabcc17885b7df73deef72d8d18157da"
    sha256 cellar: :any,                 arm64_ventura:  "7fa8aae80d9c726609936a0ec4f8190380b7df1dbfa14ef4e1a977f9e7d2988a"
    sha256 cellar: :any,                 arm64_monterey: "eb334aa3e31f6893a7692c467dfb9f69120c8bc768cb20a9dc804a87cbcfcab2"
    sha256 cellar: :any,                 sonoma:         "8de2fac44ca95e30f15a038b3cb3c7a7ca02b235d52c2828fd734175941a6fd2"
    sha256 cellar: :any,                 ventura:        "7f7f24eff4b74e2e5780d8c764b61b73b95b0db31b91a23051ba688e5f29f9d1"
    sha256 cellar: :any,                 monterey:       "f7588904e9eebfe583412424cd436929a145f3887c551f3a491b119faca12e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32a021d9e81e693117f22a3b246073fca005cd120bba948dad1cc18578c96b88"
  end

  depends_on "nasm" => :build

  def install
    system "make", "install-shared", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <wels/codec_api.h>
      int main() {
        ISVCDecoder *dec;
        WelsCreateDecoder (&dec);
        WelsDestroyDecoder (dec);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lopenh264", "-o", "test"
    system "./test"
  end
end
