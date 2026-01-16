class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "https://steveicarus.github.io/iverilog/"
  url "https://github.com/steveicarus/iverilog/archive/refs/tags/v12_0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/iverilog/iverilog_12.0.orig.tar.gz"
  sha256 "a68cb1ef7c017ef090ebedb2bc3e39ef90ecc70a3400afb4aa94303bc3beaa7d"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/steveicarus/iverilog.git", branch: "master"

  livecheck do
    url :head
    regex(/v?(\d+(?:[._]\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "6362213da330c37911b9456faf6424e41edaa8b84af9021f804ec85ce7242bba"
    sha256 arm64_sequoia:  "71feafd9b968350f08ca504f95b7d0be4e048799c47c145e2d7757ce0d179a5c"
    sha256 arm64_sonoma:   "16e03356975ad058efbf99a12cb1ed1a6c078aea5d7b5bb6a0035442afb0f335"
    sha256 arm64_ventura:  "0c963a73d69e2c0ad3c6813dd9d03ac4b5a880052bf9ecb28a8918adc9384b4e"
    sha256 arm64_monterey: "968e2d0ca44b96920ad0806c19101a4dbd888ae8f5d3f6ede6395b13ee84c35b"
    sha256 arm64_big_sur:  "af49151647a5194225563412267b0dacb3da1d3fe3777802f13788ebf098d50d"
    sha256 sonoma:         "53a13ceb942f2ae0e867fc35716853f809114b157bb1e813a9a11b798666b968"
    sha256 ventura:        "f8d395f182e8788ae9720421d2c8ba5ab90fad839e0071ed871c8a8b23484d58"
    sha256 monterey:       "f6fea867f86a544671ff8d074da509d2997f545df8fa2d47cbb118aa7029fcfa"
    sha256 big_sur:        "b5c5e18bfcdadfcc54a69954b71bf4c56f6e9c223823f65c798c442c4ec61e79"
    sha256 arm64_linux:    "36faa76b1a7d0089f202c91564fb24536d9e2cb7d446a36e51657505f1cf8e89"
    sha256 x86_64_linux:   "ee0b7b46d11a76808cebc2140d83fc615ae4bec40aa3cfbc346560532caf3cdb"
  end

  depends_on "autoconf" => :build
  # parser is subtly broken when processed with an old version of bison
  depends_on "bison" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "BISON=#{Formula["bison"].opt_bin}/bison"
  end

  test do
    (testpath/"test.v").write <<~VERILOG
      module main;
        initial
          begin
            $display("Boop");
            $finish;
          end
      endmodule
    VERILOG
    system bin/"iverilog", "-o", "test", "test.v"

    expected = <<~EOS
      Boop
      test.v:5: $finish called at 0 (1s)
    EOS
    assert_equal expected, shell_output("./test")

    # test syntax errors do not cause segfaults
    (testpath/"error.v").write "error;"
    expected = <<~EOS
      error.v:1: syntax error
      I give up.
    EOS
    assert_equal expected, shell_output("#{bin}/iverilog error.v 2>&1", 2)
  end
end
