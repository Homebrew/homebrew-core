class Cifer < Formula
  desc "Work on automating classical cipher cracking in C"
  homepage "https://code.google.com/p/cifer/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cifer/cifer-1.2.0.tar.gz"
  sha256 "436816c1f9112b8b80cf974596095648d60ffd47eca8eb91fdeb19d3538ea793"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e91e9087a69d7922fe1fe9f84e11e9f222c45d5b1b1cd794f1e7f0bf3a295c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66851780bbfe9071936bd7f230dc0f0744f5dc16ae6bd5986d9494d31563b75b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f826a8dc0534a56e2c372abeba0f05124f79e96502243d1c89548777d2156b2"
    sha256 cellar: :any_skip_relocation, ventura:        "8d266e4601b71e979f7580f3fe3eeb6aafe4aa5c350bf5db2f1fcf4950e556ed"
    sha256 cellar: :any_skip_relocation, monterey:       "efc874dcf1bfb9fb07faab3de50b204897e1daf172f74fd00d75a0a5e421036f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f58f511d07f6a8daf8c868915c1de59f23d33c089da52271da83180e321bab5b"
    sha256 cellar: :any_skip_relocation, catalina:       "ce4a7d9b846388eae2309dbd0a1f0493b533cbefef85ae50ff97648b6a46600c"
    sha256 cellar: :any_skip_relocation, mojave:         "ed647fac83a0f0605c4fbf0492be1568199a60473e20ac455feb4ff1abea1946"
    sha256 cellar: :any_skip_relocation, high_sierra:    "04d95a6448d38450079196139c6e6d5b5811265444c9abf8fe93b7424181a222"
    sha256 cellar: :any_skip_relocation, sierra:         "875e676d7866fd3ba2c8b70806838068775ffbc1102c56ca52d041155b2ade43"
    sha256 cellar: :any_skip_relocation, el_capitan:     "86cbc00f11a5818f48ee67bdc0fa5f2692cc7f37ae6c2c5eb237338c7dc6919b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58a55640d9031cea1c50d8ad9db0128993f4e5895ccf7a9069f762c34682e165"
  end

  on_linux do
    depends_on "readline"

    # Fix order of linker flags for GCC
    patch :DATA
  end

  def install
    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/cifer")
  end
end

__END__
--- a/Makefile
+++ b/Makefile
@@ -54,7 +54,7 @@ allfiles := $(wildcard *)
 all : cifer
 
 cifer : $(objects)
-	$(CC) $(CFLAGS) $(LINKLIBS) -o $@ $(objects)
+	$(CC) $(CFLAGS) -o $@ $(objects) $(LINKLIBS)
 
 src/%.o : src/%.c $(headers)
 	$(CC) $(DEFS) -c $(CFLAGS) $< -o $@
