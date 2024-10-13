class Plzip < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.11.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/plzip/plzip-1.11.tar.gz"
  sha256 "d8e3cbe45c9222383339130e1bcc6e5e884d776b63f188896e6df67bc1d5626b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/plzip/"
    regex(/href=.*?plzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2f4918f35a1c74cbd741ade3f65f52ac0109b20f31e529c8d78844e7e442a702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7ed4608e48fc82bb1570ada081e9e425f4c51ec37dc40cf78599b610a3ff9fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fd52379b6800e5a8040a4586069dc837b4e902cf31e98c212ea341579e48a3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80f66ad184dcd6b079d226119667004ca63c877a9227c781988826bd4fbee76c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a007f3feecd82329c6c76e230c3686d8a174d9028860e0dd3edf03fac07ba68"
    sha256 cellar: :any_skip_relocation, ventura:        "0d5589eed9ac420cab422f50a22f4b48f8ad70e06b948367e208db5ebf90ce51"
    sha256 cellar: :any_skip_relocation, monterey:       "f25f2b228adb941a62a793f5542c14cdbd03defabac4e57fb5233cb3a92b3937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "523c2e22ef52117ff7eaa2d12f6e8d374d5f8cf39897a47df3e71e78fb32a85a"
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
