class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "https://bellard.org/bpg/"
  url "https://bellard.org/bpg/libbpg-0.9.8.tar.gz"
  sha256 "c0788e23bdf1a7d36cb4424ccb2fae4c7789ac94949563c4ad0e2569d3bf0095"

  bottle do
    cellar :any
    sha256 "53691575bb5076233228a76e6657a76af4fcc0ab90f3f54799489e54dbe1a49a" => :mojave
    sha256 "b040d31f8abd45f50f8ba634c97eb81a0ec89ecada773223b2ac362ddd20baff" => :high_sierra
    sha256 "77ae8a79d99cae86c42e4eaad0cc240efe98425f58143c940a3525d29d7cb25c" => :sierra
    sha256 "49027f81f126e8bdc24587d43b127815e3a53fafa92b6326c857526678932bef" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build
  depends_on "jpeg"
  depends_on "libpng"

  def install
    bin.mkpath
    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y"
    pkgshare.install Dir["html/bpgdec*.js"]
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
