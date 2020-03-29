class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "https://github.com/steveicarus/iverilog/archive/v10_3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/iverilog/iverilog_10.3.orig.tar.gz"
  sha256 "4b884261645a73b37467242d6ae69264fdde2e7c4c15b245d902531efaaeb234"
  head "https://github.com/steveicarus/iverilog.git"

  bottle do
    sha256 "bf40a384b8432dfb72276e31e87d550b9b47515dc68bdfb25f0cde9becd4ac10" => :catalina
    sha256 "0237851e478bcb76567111f14c1e42fe79161a8cd28ca04127295fc40db14113" => :mojave
    sha256 "96a15af23212d29f9410e073418c9388447955245fa8c38cf3b27ccf8fabd178" => :high_sierra
    sha256 "ded40d14a1cd74f2b764d9cf667d48ee8b6c010e77d88ca47afc99188ace1255" => :sierra
  end

  depends_on "autoconf" => :build
  # parser is subtly broken when processed with an old version of bison
  depends_on "bison" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
