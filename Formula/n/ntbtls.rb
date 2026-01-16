class Ntbtls < Formula
  desc "Not Too Bad TLS Library"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/ntbtls/ntbtls-0.3.2.tar.bz2"
  sha256 "bdfcb99024acec9c6c4b998ad63bb3921df4cfee4a772ad6c0ca324dbbf2b07c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/download/"
    regex(/href=.*?ntbtls[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3b087b31c57533e6cb4ab903dd86588239435abd414625856b9cffe2b4d77648"
    sha256 cellar: :any,                 arm64_sequoia:  "0b1672e39923c23daf86bb20ba920ba31144e4a2ab95218cab6c8b45d979a534"
    sha256 cellar: :any,                 arm64_sonoma:   "ab4d5a53bb700d479e6be04b5d749b8c65947be1bf2800120ccb706b2608af1d"
    sha256 cellar: :any,                 arm64_ventura:  "acec598404ed6699950460cb1df48690c6439eb2c79310c29c81a020fee5cbe7"
    sha256 cellar: :any,                 arm64_monterey: "d5406167e6466323874ab9402e80e9ee0bde98c6b623f89a819f710483f3b62a"
    sha256 cellar: :any,                 sonoma:         "2e18052aa9a13285b91aee389a8dd972709598a1b493bc16611a9a8c2e4e82ed"
    sha256 cellar: :any,                 ventura:        "0aa20fe8898d11f765b3b06d5ceef09fb95aa25680177d31742c7780fcb3f56e"
    sha256 cellar: :any,                 monterey:       "325ae328b6d7b3979026fab41d9b6e1bf2b1977635a444d5aa46feb4203f3941"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a2c56e174f8142aed89b36666fe8fb3e325b3c3a881c2765b014493eec9ef471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "535750dc2867eebec1d2e416ae1f586284316f18ae56ca35dcb0edbc5b7e110c"
  end

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}",
                          "--with-libksba-prefix=#{Formula["libksba"].opt_prefix}"
    system "make", "check" # This is a TLS library, so let's run `make check`.
    system "make", "install"
    inreplace bin/"ntbtls-config", prefix, opt_prefix
  end

  test do
    (testpath/"ntbtls_test.c").write <<~C
      #include "ntbtls.h"
      #include <stdio.h>
      int main() {
        printf("%s", ntbtls_check_version(NULL));
        return 0;
      }
    C

    ENV.append_to_cflags shell_output("#{bin}/ntbtls-config --cflags").strip
    ENV.append "LDLIBS", shell_output("#{bin}/ntbtls-config --libs").strip

    system "make", "ntbtls_test"
    assert_equal version.to_s, shell_output("./ntbtls_test")
  end
end
