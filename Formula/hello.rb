class Hello < Formula
  desc "Program providing model for GNU coding standards and practices"
  homepage "https://www.gnu.org/software/hello/"
  url "https://ftp.gnu.org/gnu/hello/hello-2.12.tar.gz"
  sha256 "cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb2c428f4d0667df4049a1a94b8ecc7ceb3a63be30423dbdcee77bdee859cd7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfbce13d943feb89318c14f97cc71d686b4c59100dde0f125b7cf086ae491fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "557501b7ccf982b496e484b0be41ec3e85f6d8f5ad18e99c950fb61f4b57f2ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dd1beef8bfcc1c4bf1aa6dbd4baf262419fef189e8dffa72455853c0236fd59"
    sha256 cellar: :any_skip_relocation, catalina:       "8368282ba548c6c551d1ab9374cbfb93304cbd890092a156d851b6bfe19f2931"
    sha256                               x86_64_linux:   "f262a5395166c745eddcd002d029f4b1d8461976251330c5fd1ee1ef5599aab8"
  end

  conflicts_with "perkeep", because: "both install `hello` binaries"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    assert_equal "brew", shell_output("#{bin}/hello --greeting=brew").chomp
  end
end
