class Cifer < Formula
  desc "Work on automating classical cipher cracking in C"
  homepage "https://code.google.com/p/cifer/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cifer/cifer-1.2.0.tar.gz"
  sha256 "436816c1f9112b8b80cf974596095648d60ffd47eca8eb91fdeb19d3538ea793"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0ddcaf5c7910b356424491a71c0b42587701427aba17e0fdc02a9c088c148590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8d9f5339ed8c92d74cc50214716df2c6082a559fdf26b004ff69e0468e3faf0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b6a222301feeb2df2db2337c86c5c5e0223e17d5df33bab506f5be9b9d7cd62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e91e9087a69d7922fe1fe9f84e11e9f222c45d5b1b1cd794f1e7f0bf3a295c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66851780bbfe9071936bd7f230dc0f0744f5dc16ae6bd5986d9494d31563b75b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f826a8dc0534a56e2c372abeba0f05124f79e96502243d1c89548777d2156b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf13c997d4f8277ffb99f4e05669a4dc91eaafa1ab520df56c36a1fcfcf8d39f"
    sha256 cellar: :any_skip_relocation, ventura:        "8d266e4601b71e979f7580f3fe3eeb6aafe4aa5c350bf5db2f1fcf4950e556ed"
    sha256 cellar: :any_skip_relocation, monterey:       "efc874dcf1bfb9fb07faab3de50b204897e1daf172f74fd00d75a0a5e421036f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f58f511d07f6a8daf8c868915c1de59f23d33c089da52271da83180e321bab5b"
    sha256 cellar: :any_skip_relocation, catalina:       "ce4a7d9b846388eae2309dbd0a1f0493b533cbefef85ae50ff97648b6a46600c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1788d000c6819db964bdee6be927657035fd8e7b716987a200b8b569a3153cf1"
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
    assert_match version.to_s, pipe_output(bin/"cifer")
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
