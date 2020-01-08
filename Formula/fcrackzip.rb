class Fcrackzip < Formula
  desc "Zip password cracker"
  homepage "http://oldhome.schmorp.de/marc/fcrackzip.html"
  url "http://oldhome.schmorp.de/marc/data/fcrackzip-1.0.tar.gz"
  sha256 "4a58c8cb98177514ba17ee30d28d4927918bf0bdc3c94d260adfee44d2d43850"

  bottle do
    cellar :any_skip_relocation
    sha256 "553e2ed7eb76dcf4a216bf214e0ceed63a72bda2e7fe9f5fb5f2ed86d8e7bfb8" => :catalina
    sha256 "9ac33112f0cb584aca3ac383ca3551cdda570e6f7337607c7f7db9d7f51b2e3a" => :mojave
    sha256 "a90e9d404b0ef939f6419559ed58143f556eb3e0b4fb0b8053bae35b82cc7a15" => :high_sierra
    sha256 "ce2d79b833f5805cbc475711a38db0a7a791b793b24b094e68f3ed54dfe5fd82" => :sierra
    sha256 "169a5e7ea0e7ee9d04dc7ecce5288ef3a096fc9875d9af134b342878ce8c55fd" => :el_capitan
    sha256 "1e9a5e3d9d37ce1bf7338d3f12f84bf67b31de4e2a6eb1511f90458c45b1b810" => :yosemite
    sha256 "305533df364c7b91ae837dc38b3632bc9e2f0d167e10ad94901b5f2c06ab4924" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"secret").write "homebrew"
    system "zip", "-qe", "-P", "a", "secret.zip", "secret"
    assert_equal "PASSWORD FOUND!!!!: pw == a",
                 shell_output("#{bin}/fcrackzip -u -l 1 secret.zip").strip
  end
end
