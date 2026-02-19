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
    rebuild 1
    sha256 arm64_tahoe:   "51668d00e6a1130a0788dd9d7291e2758e1040a6ec112376edfcccd4925ddac2"
    sha256 arm64_sequoia: "7911ddab9cff947d0fee3c45f6d304af8e30abaca45adafc1d7f12beffde6b59"
    sha256 arm64_sonoma:  "a935c5891520a801dafc403ae7e0bc724f0a9fcca8df9227706a9fd74fb44015"
    sha256 sonoma:        "dd0bf128e18ade51f0e0400ff74ce97bf87e02a62ab976107a361991853e5858"
    sha256 arm64_linux:   "56afa46c684a210fec8b7792b50b086bc07ff5b8f934b559e88380f4e884481f"
    sha256 x86_64_linux:  "bc29fdcee8a32639e6d1b7cca55b5a6898326bae132051f0f567e0eeddb339c0"
  end

  depends_on "autoconf" => :build
  # parser is subtly broken when processed with an old version of bison
  depends_on "bison" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
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
