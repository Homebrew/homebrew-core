class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "https://github.com/steveicarus/iverilog/archive/v11_0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/iverilog/iverilog_11.0.orig.tar.gz"
  sha256 "6327fb900e66b46803d928b7ca439409a0dc32731d82143b20387be0833f1c95"
  license "LGPL-2.1"
  head "https://github.com/steveicarus/iverilog.git"

  livecheck do
    url "https://github.com/steveicarus/iverilog/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 "99791a3fd0891487586c49112fa3293e65320e651bbf9c03f15a58b456e96e6e" => :catalina
    sha256 "92851adfb43caad0826da2bf74706c15e6fffc2e32b2b003e19659b0e6a4542b" => :mojave
    sha256 "a92f6fe981238a8c2b9f47b99d77c1e8596bc74235b8f6601835aae8f9ad70a1" => :high_sierra
  end

  depends_on "autoconf" => :build
  # parser is subtly broken when processed with an old version of bison
  depends_on "bison" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gperf" => :build
    depends_on "readline"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    # https://github.com/steveicarus/iverilog/issues/85
    ENV.deparallelize
    system "make", "install", "BISON=#{Formula["bison"].opt_bin}/bison"
  end

  test do
    (testpath/"test.v").write <<~EOS
      module main;
        initial
          begin
            $display("Boop");
            $finish;
          end
      endmodule
    EOS
    system bin/"iverilog", "-otest", "test.v"
    assert_equal "Boop", shell_output("./test").chomp

    # test syntax errors do not cause segfaults
    (testpath/"error.v").write "error;"
    assert_equal "-:1: error: variable declarations must be contained within a module.",
      shell_output("#{bin}/iverilog error.v 2>&1", 1).chomp
  end
end
