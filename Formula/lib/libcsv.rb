class Libcsv < Formula
  desc "CSV library in ANSI C89"
  homepage "https://sourceforge.net/projects/libcsv/"
  url "https://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.3/libcsv-3.0.3.tar.gz"
  sha256 "d9c0431cb803ceb9896ce74f683e6e5a0954e96ae1d9e4028d6e0f967bebd7e4"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "7e68ec2e60c356c84b0e330ad076afc58f0eb71eecd953ab4075821d835eb84d"
    sha256 cellar: :any,                 arm64_sequoia:  "c515471cacac39d4bdb089b73f0ca8f2405a7c90b7973203fda68ab10c28a630"
    sha256 cellar: :any,                 arm64_sonoma:   "5ffc7fff79c22779c3c5e74f553511a5d160be80d2fa147f675db2631af542fa"
    sha256 cellar: :any,                 arm64_ventura:  "98c6f484207a9291a7d5696a9eff9ecdb6c6579834b86f8df8731ae61d8f3f4e"
    sha256 cellar: :any,                 arm64_monterey: "37da5ecb6f4175cf6e044d2cd5a5797ffd20ddac9631d5b2bb54b2db53f3dab1"
    sha256 cellar: :any,                 arm64_big_sur:  "5fab325e7caac0db2cb892eebd55b5ef1094b92eaa3413bdd9ce85f47d82ff17"
    sha256 cellar: :any,                 sonoma:         "1f49d10bf54d93ac9b3ea032385ed32d9e148adb401bd004b8698cc4fe715529"
    sha256 cellar: :any,                 ventura:        "975bc0968b6d54eb26b6d21983086472cd473159163e525080e6ece157a3cc58"
    sha256 cellar: :any,                 monterey:       "6c4f06b89f9dea054ca3ee012d70b83268b9df1943b7e002a58b442f55ea126e"
    sha256 cellar: :any,                 big_sur:        "4edab615e912a3a0e931fff1b4f594093cfa1c4bc4869340046300b181f9ebc5"
    sha256 cellar: :any,                 catalina:       "e596efc37a1bf77cdbbab5fdc904e6ffa796f221b3ffa531f3ac24f56237d18a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a313d8dd11bc697e7f0f45e36572a38c6a86c827b0309a564849c443ea573a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a66bd666958e3125f08377688cf86c94cd38e077bedea9a70cb17c721794211f"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <csv.h>
      int main(void) {
        struct csv_parser p;
        csv_init(&p, CSV_STRICT);
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcsv", "-o", "test"
    system "./test"
  end
end
