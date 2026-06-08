class Erfa < Formula
  desc "Essential Routines for Fundamental Astronomy"
  homepage "https://github.com/liberfa/erfa"
  url "https://github.com/liberfa/erfa/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "d5469fbd0b212b3c7270c1da15c9bd82f37da9218fc89627f98283d27b416cbf"
  license "BSD-3-Clause"
  head "https://github.com/liberfa/erfa.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1ddfe8f2240132e262a4bf6c0ce8aaced1eff640123b43c27355093910bf0482"
    sha256 cellar: :any,                 arm64_sequoia: "ae0cd3901d1bbb3fb7b002b6e141ac41044566dfb35270e82726ce6aad7a6832"
    sha256 cellar: :any,                 arm64_sonoma:  "c80d1ca1747d562c186b39a15f8b0e86483d80ebaf5b94a28445bae4596a54b8"
    sha256 cellar: :any,                 sonoma:        "ae5d54e5f2a440bf188c3c37c26bce3689a5e7f9374686759b182d62860b6695"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee7b6f9abbca3a1da91236d6d9385846b6101862df8f072cd5ff65bfbe396e8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acfd3e927c52ecefe72e13b0ae7fbe322ac9e2d7dd03678afd77aac77ad649c0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <erfa.h>
      #include <erfaextra.h>
      #include <stdio.h>
      #include <string.h>
      int main() {
        /* Test version functions */
        char buf[16];
        sprintf(buf, "%d.%d.%d", eraVersionMajor(), eraVersionMinor(), eraVersionMicro());
        if (strcmp(buf, "#{version}") != 0) {
          printf("Version mismatch: expected #{version}, got %s\\n", buf);
          return 1;
        }

        /* Test calculation (Degrees to Degrees, Minutes, Seconds) */
        int idmsf[4];
        char s;
        eraA2af(4, 2.345, &s, idmsf);
        if (s != '+' || idmsf[0] != 134 || idmsf[1] != 21 || idmsf[2] != 30 || idmsf[3] != 9706) {
          return 1;
        }

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lerfa", "-o", "test"
    system "./test"
  end
end
