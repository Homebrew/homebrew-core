class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "https://steveicarus.github.io/iverilog/"
  url "https://github.com/steveicarus/iverilog/archive/refs/tags/v13_0.tar.gz"
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
    rebuild 1
    sha256 arm64_golden_gate: "de6f721fcebd0ab67e29fc79de453070923656103260720973c96151de5f2d54"
    sha256 arm64_tahoe:       "0c26b4d54f2a1264a7b9105345192f303ffaa79e7e164cf705baa3c2df275871"
    sha256 arm64_sequoia:     "97e471a63c9695bdca2c6eee0926806c0fd145badb541b705f38431793de8b68"
    sha256 arm64_linux:       "150345153865a080048abedf7de640c392375cb169a694a9fda7910133816e26"
    sha256 x86_64_linux:      "d4c34b63ee3b8f2e6286fb71e4f4ba116e5d0e5142a0fdd499250a022607de3d"
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

  # Backport fix for missing mach-o/dyld.h include on macOS 27 SDK
  patch do
    url "https://github.com/steveicarus/iverilog/commit/f20865a5ea4ea7f5cdcbb6d19b0751a9390a8978.patch?full_index=1"
    sha256 "a56837d524f2a7f6bc05435601d7951cd1bdb94fb7ce3c0d43aa774475da6d52"
    type :backport
    resolves "https://github.com/steveicarus/iverilog/pull/1315"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "BISON=#{formula_opt_bin("bison")}/bison"
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
