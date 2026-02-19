class Libnova < Formula
  desc "Celestial mechanics, astrometry and astrodynamics library"
  homepage "https://libnova.sourceforge.net/"
  url "https://git.code.sf.net/p/libnova/libnova.git",
      tag:      "v0.16",
      revision: "edbf65abe27ef1a2520eb9e839daaf58f15a6941"
  # libnova is LGPL but the libnovaconfig binary is GPL
  license all_of: ["LGPL-2.0-or-later", "GPL-2.0-or-later"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd79a01fd5a7306387bce5efbc22a21740446e9b8f6297bcd7c5dc2d9af64284"
    sha256 cellar: :any,                 arm64_sequoia: "ffa8ba8b5274d3a3860f9f3fdcd77ac6dde469714b22627b3cde37126b96b04a"
    sha256 cellar: :any,                 arm64_sonoma:  "2067747e334b62d6581f3923428dd98b9dabffd0b103a6a35e3c68bbeee44043"
    sha256 cellar: :any,                 sonoma:        "b8882a09bc05971cd86c3388602583dce5fd173b8426d2338e091ae67bd3ed1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6f726ab15a2116d490f86ae09682688ee25eaca2804564b2d38d40d09030407"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c724966987330961113e03102032bbba991585716037b228750afec5e58d7d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libnova/julian_day.h>

      int main(void)
      {
        double JD;

        JD = ln_get_julian_from_sys();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnova", "-o", "test"
    system "./test"
  end
end
