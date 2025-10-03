class Freealut < Formula
  desc "Implementation of OpenAL's ALUT standard"
  homepage "https://github.com/vancegroup/freealut"
  url "https://deb.debian.org/debian/pool/main/f/freealut/freealut_1.1.0.orig.tar.gz"
  sha256 "60d1ea8779471bb851b89b49ce44eecb78e46265be1a6e9320a28b100c8df44f"
  license "LGPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/freealut/"
    regex(/href=.*?freealut[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b10fa1d850fc453e04334c8e607bc944fdf9bc8e794e480d30ce53a5d2319ab5"
    sha256 cellar: :any,                 arm64_sequoia:  "74fb9b51f64c8f9683e853836bf34c519fe2dc3d58d97a44b0db070bf7b737cf"
    sha256 cellar: :any,                 arm64_sonoma:   "0e38d6b21c45fe87a07e97bbdee177a22de254c35873f5d3b6cd17c896221af5"
    sha256 cellar: :any,                 arm64_ventura:  "7d9a63d859ffb514a2e4a7518d18bcbc7b71fb79c1580e00fa71c2107d794be6"
    sha256 cellar: :any,                 arm64_monterey: "b8def26cf41acf2dc5d3e349ec3e8429df7cc8c22c09f6efc237796653d01561"
    sha256 cellar: :any,                 arm64_big_sur:  "3cdedc8bdb746d9b619372b514e021eb40f51a83f01db883167d55322cb5286a"
    sha256 cellar: :any,                 sonoma:         "920b3dbfa2b1cf0741f5ed96cad98291de73481b93c09c25598ae32844fcec32"
    sha256 cellar: :any,                 ventura:        "e538e0e346fe29aadb9df1856ef2291cf3c897edd1d6aa79ba1ad5218262c895"
    sha256 cellar: :any,                 monterey:       "8b5449831c37f8dac468aaf8e2a4ccb8ea17acbfebf0a4a831bb864d7d1d5834"
    sha256 cellar: :any,                 big_sur:        "16375ee0d022401f8d83ea01540d088ffc90e5661c10370b4157e13c617061fb"
    sha256 cellar: :any,                 catalina:       "7b37a28c1edf58222ec10227bfbc0129cdd0afe66167c232fc62527bf89333c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "55fd0316cf15d4add92c729d3c27b3847d377b1778e89b251c15056084d8ec5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05ed720d9817268e8941fba68a2d52e685562119fe2d79eba3f6ec107864d191"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Adds the OpenAL frameworks to the library list so linking succeeds
  on_macos do
    patch :DATA
  end

  on_linux do
    depends_on "openal-soft"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 2b26d6d..4001db1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -83,7 +83,8 @@ AC_DEFINE([ALUT_BUILD_LIBRARY], [1], [Define to 1 if you want to build the ALUT

 # Checks for libraries. (not perfect yet)
 AC_SEARCH_LIBS([pthread_self], [pthread])
-AC_SEARCH_LIBS([alGetError], [openal32 openal])
+# Use Mac OS X frameworks
+LIBS="$LIBS -framework IOKit -framework OpenAL"

 ################################################################################
 # Checks for header files.
