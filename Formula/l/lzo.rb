class Lzo < Formula
  desc "Real-time data compression library"
  homepage "https://www.oberhumer.com/opensource/lzo/"
  url "https://www.oberhumer.com/opensource/lzo/download/lzo-2.10.tar.gz"
  sha256 "c0f892943208266f9b6543b3ae308fab6284c5c90e627931446fb49b4221a072"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.oberhumer.com/opensource/lzo/download/"
    regex(/href=.*?lzo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9863be33af38858d028657bdfbceaff00465b23a9857ce6ed93e2ad24f6adbd8"
    sha256 cellar: :any,                 arm64_sequoia:  "6bb0401c41a18fd37071ec9591fe053a808f07552ff7ea22542faa470eb8e589"
    sha256 cellar: :any,                 arm64_sonoma:   "167749edd2052e4c577f27c79a41eb1cb4b79302b1e4bef1e4cfb29bd50aedd9"
    sha256 cellar: :any,                 arm64_ventura:  "a565c627b13f2dc7fc4550aa8290a4c3feb2f48fcaa45c9f7f4bc4fe4535aa66"
    sha256 cellar: :any,                 arm64_monterey: "e16072e8ef7a8810284ccea232a7333a2b620367814b133a455217d22e89ae8e"
    sha256 cellar: :any,                 arm64_big_sur:  "76d0933f626d8a1645b559b1709396a2a6fd57dbd556d2f1f1848b5fddfcd327"
    sha256 cellar: :any,                 sonoma:         "11b8557744feb28974cb4caa92a16a89f3ead77468778cc17c2f349502df495e"
    sha256 cellar: :any,                 ventura:        "ac88f2fdcb7eb5f82e1e6b2459408f2ca3db299d2366b7af64e410a3c6629b52"
    sha256 cellar: :any,                 monterey:       "0a20a578e6a31ebbe3c5d708af38b1c3ca5ba503612ed28a197cd326505d31dd"
    sha256 cellar: :any,                 big_sur:        "fcd3c9f7042104ca13be96fd0ec53acdc7da1480c16140441b2e66d4e7c5eb78"
    sha256 cellar: :any,                 catalina:       "c8f55ba0de85273c1851136f47b89f43ba3cce9cbf0ba9f2bba7db311544a000"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d090d9756c7eb1a5371f8eff88273c0301b0102c8bf6f47d9fad7d876a466902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8413f94bb69f337f7e1837e7f525e703cac105d27ceeb29de5c08c7bbfa77b29"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <lzo/lzoconf.h>
      #include <stdio.h>

      int main()
      {
        printf("Testing LZO v%s in Homebrew.\\n",
        LZO_VERSION_STRING);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_match "Testing LZO v#{version} in Homebrew.", shell_output("./test")
  end
end
