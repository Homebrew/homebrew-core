class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "ftp://icarus.com/pub/eda/verilog/v10/verilog-10.2.tar.gz"
  sha256 "96dedbddb12d375edb45a144a926a3ba1e3e138d6598b18e7d79f2ae6de9e500"

  bottle do
    sha256 "81e937d3d6a5f7b22271e79b73618e96db1e52ee491eaf3506671cfb5891c129" => :high_sierra
    sha256 "fcfa2c2480d6f113dde2ac3d97a4c8ece20881df36edc5f5c59bb9f4bb8139ea" => :sierra
    sha256 "b517bb8d1a5a6cfda00e32f403950e32b88c8792b1e74e9011c5036a0e44bba6" => :el_capitan
  end

  head do
    url "https://github.com/steveicarus/iverilog.git"
    depends_on "autoconf" => :build
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    # https://github.com/steveicarus/iverilog/issues/85
    ENV.deparallelize
    system "make", "install"
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
  end
end
