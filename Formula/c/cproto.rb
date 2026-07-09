class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.8.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.8.orig.tar.gz"
  sha256 "0cccb93447682c7fdb4f0bdbfbe05d52a827331e0a19a5215d2c3cb85ad29258"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/cproto/"
    regex(/href=.*?cproto[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84ce33c221055ccd792d10a188bc64dda96d8e014e6801d76ad80cd8e1687dd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92840143bd7192644d77d2426af1f49b25306c60fe4b1996c71ed71450a63304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f09794f06dadb594c23b1a348cdda0426e9103d9f28ad95782ea319ca34f75a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cbed2496dde17c6c9a19a5fe2f078a107a4bb471890d0682a20b36b9edfd4b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6666e4b8d52da721885cc6284763218469146336e80d2dfe6ad5b92b625c7ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b2ae2f9ba840140deca9036409f24699c5cebff60d8645b50d28a71900902ab"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end
