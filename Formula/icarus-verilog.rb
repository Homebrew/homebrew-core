class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "ftp://icarus.com/pub/eda/verilog/v10/verilog-10.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/iverilog/iverilog_10.3.orig.tar.gz"
  sha256 "86bd45e7e12d1bc8772c3cdd394e68a9feccb2a6d14aaf7dae0773b7274368ef"

  bottle do
    sha256 "22e4b636b8a68f5b2738c619e5d8093af32a58ee818b2c594de14e5a4b9234c8" => :mojave
    sha256 "8e4f4c412b26be688684ed14715b4cc80a14eba73dd30d5e8b8faf93a1eae6e9" => :high_sierra
    sha256 "579e249fe16e0151d98ad2829a4817e75aa12e5943734e0e60bf8397764f593c" => :sierra
    sha256 "696c7b11f0b3127c22fd839b3f32645b03335a0c24f6cf0b965e96c7bb756815" => :el_capitan
  end

  head do
    url "https://github.com/steveicarus/iverilog.git"
    depends_on "autoconf" => :build
  end

  # parser is subtly broken when processed with an old version of bison
  depends_on "bison" => :build

  def install
    system "autoconf" if build.head?
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
