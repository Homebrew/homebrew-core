class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.8.0.tar.bz2"
  sha256 "296b9db9095749f2aa104202d7ab7fd09ad10710e00780a709c9754b1a1d9292"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a14ed50998df34e93b8eeedea30c7b953ebd07d2de779f6f040bcb628a8c03f0"
    sha256 cellar: :any,                 arm64_sequoia: "0f0fe7be0551bbc43def382b1a57b6c9c0cd389d9f6ff94e4814f13d874d57ab"
    sha256 cellar: :any,                 arm64_sonoma:  "0d6ac900bba8a7db4d070d0dc105c6d2e1dc4d7db114eada045e05a36b730c94"
    sha256 cellar: :any,                 sonoma:        "e628ca384fbbd51f879713e75c9c7fbd8c006ebb0774568acb47b92c31b87642"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daf8a2212c7bee6a9af2eb0ddf9a56c8c6f6d112f0520ec699b009a2fe837afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5518938a0b0907d4d12c0153dcba08245d65442e7ee1c0a5663e5935b591305"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace [bin/"ksba-config", lib/"pkgconfig/ksba.pc"], prefix, opt_prefix
  end

  test do
    (testpath/"ksba-test.c").write <<~C
      #include "ksba.h"
      #include <stdio.h>
      int main() {
        printf("%s", ksba_check_version(NULL));
        return 0;
      }
    C

    ENV.append_to_cflags shell_output("#{bin}/ksba-config --cflags").strip
    ENV.append "LDLIBS", shell_output("#{bin}/ksba-config --libs").strip

    system "make", "ksba-test"
    assert_equal version.to_s, shell_output("./ksba-test")
  end
end
