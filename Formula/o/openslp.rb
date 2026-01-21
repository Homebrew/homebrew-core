class Openslp < Formula
  desc "Implementation of Service Location Protocol"
  homepage "http://www.openslp.org"
  url "https://downloads.sourceforge.net/project/openslp/2.0.0/2.0.0%20Release/openslp-2.0.0.tar.gz"
  sha256 "924337a2a8e5be043ebaea2a78365c7427ac6e9cee24610a0780808b2ba7579b"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "03318a808866a33ea675a2520d6d889c9aa74f6817b9a30bed9bbc0cf4a6938d"
    sha256 arm64_sequoia: "8ad62fa05cfa66977820ce7095c95f7f3f9573fe8c11565cc80adb9767bb3ae2"
    sha256 arm64_sonoma:  "88497463ae4bc988432fe2ec15a032ee2f4ea3516d8915405a08256c265633ee"
    sha256 sonoma:        "9f8b91c18c4a8e0738618531ad35f6068daa27cb6069362510622592113aada5"
    sha256 ventura:       "517653bc27072c320f9159e57040c51d5ba0b4ea8b234bb5af9af55a9aea9f42"
    sha256 arm64_linux:   "7f3de41c36959025ce20d867cfa90c065fba46d872b055d0b7c2a2e6a631b44d"
    sha256 x86_64_linux:  "aa1988503f1e9688dfd80e0331392ab29a053e62197b60653e933ee1bc681efb"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    # Workaround for arm64 macOS to use fallback global mutex as USE_APPLE_ATOMICS
    # condition uses deprecated functions and code doesn't compile
    # Issue ref: https://github.com/openslp-org/openslp/issues/19
    inreplace "common/slp_atomic.c", <<~C, "#else\n" if OS.mac? && Hardware::CPU.arm?
      #elif defined(__APPLE__)
      # define USE_APPLE_ATOMICS
      #else
    C

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <slp.h>

      int main(void) {
        SLPHandle hslp;
        SLPError err;
        err = SLPOpen("en", SLP_FALSE, &hslp);
        SLPClose(hslp);
        return err;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lslp"
    system "./test"
  end
end
