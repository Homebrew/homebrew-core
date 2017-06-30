class Pick < Formula
  desc "Utility to choose one option from a set of choices"
  homepage "https://github.com/calleerlandsson/pick"
  url "https://github.com/calleerlandsson/pick/releases/download/v1.7.0/pick-1.7.0.tar.gz"
  sha256 "950531c56edc4be375fe4e89291caa807322b298143043e2e2963de34e96de15"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cb2e68d97e5258e79e08effbc4800aebc9f134beb503a877e50c79436b71f98" => :sierra
    sha256 "f26c1948463218fcd2d9c99d8fd114974d70de8e28a160cd30cc63237db0f2e5" => :el_capitan
    sha256 "eef9be3cecfc764fbe796c703448a31dd1d9a9f84d28f3df71fd65d280369e37" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pick", "-v"
  end
end
