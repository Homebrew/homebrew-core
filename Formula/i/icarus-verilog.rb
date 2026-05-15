class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "https://steveicarus.github.io/iverilog/"
  url "https://github.com/steveicarus/iverilog/archive/refs/tags/v13_0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/iverilog/iverilog_13.0.orig.tar.gz"
  sha256 "c897bbfa9848688982c6d5c30529fc29d68df0b9ff22ffa73bad89db73a7ce49"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/steveicarus/iverilog.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_tahoe:   "9171910a21536b9bcb60e0de5b11f3d2ebc31f211cae962ad6e520ecfdba1175"
    sha256 arm64_sequoia: "735d87e08978e857b0bd1771c7efdd91769ada308f8597400f16a560f72cbff7"
    sha256 arm64_sonoma:  "936627d8dfbb9996d55b3f3044f6bdf45e433df0c5fe9d0f8390f1a35714978b"
    sha256 sonoma:        "2eb03352145134b01eec88e2426a5bb066952c60f13c5d8b90067c6674ab56fe"
    sha256 arm64_linux:   "04bdad86ad33286674ae98446235a96c1719df5bbf1fe4e85015da8031d4011b"
    sha256 x86_64_linux:  "4aa2049753c29d8acb09a61dbcc98029dd0155111b39a8605aefbc024bd974a1"
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
