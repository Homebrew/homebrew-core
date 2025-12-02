class Libowfat < Formula
  desc "Reimplements libdjb"
  homepage "http://www.fefe.de/libowfat/"
  url "http://www.fefe.de/libowfat/libowfat-0.34.tar.xz"
  sha256 "d4330d373ac9581b397bc24a22ad1f7f5d58a7fe36d9d239fe352ceffc5d304b"
  license "GPL-2.0-only"
  head ":pserver:cvs:@cvs.fefe.de:/cvs", using: :cvs

  livecheck do
    url :homepage
    regex(/href=.*?libowfat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc30d254df3bcd360e4f3171d2afc99997cadfec8fd46a90f2c56991677ee87b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3846b7776a5350100cf8a734e0a45fcbe822f53128ab88bce24cfb259b3d27c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60f9182c837f2b6ff6a79e76e7c4965c717055448b3c2928baf297fd944c3035"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9f9d4615bb4f889dad22f8b880d2e197a7fb0caa7f48d20acb459ad868635d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0c8d5df1d6c01a6d36098ad87a856d8a223df535e5829ada59ecde849e54bd4"
    sha256 cellar: :any_skip_relocation, ventura:       "7f442fd43af0708854473e6c97e5da531f8b1605180bc237e815beae3e40cf55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17c1d34c4f362a68196eef92ec8d8621a4af98d94e5120a637cca1c987f20bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9033e9d8c499e2a37af9a3b0110206e494306bbc855e7e9d16d3cd3adf291801"
  end

  def install
    system "make", "libowfat.a"
    system "make", "install", "prefix=#{prefix}", "MAN3DIR=#{man3}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libowfat/str.h>
      int main()
      {
        return str_diff("a", "a");
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lowfat", "-o", "test"
    system "./test"
  end
end
