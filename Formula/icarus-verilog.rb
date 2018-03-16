class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "ftp://icarus.com/pub/eda/verilog/v10/verilog-10.2.tar.gz"
  sha256 "96dedbddb12d375edb45a144a926a3ba1e3e138d6598b18e7d79f2ae6de9e500"

  bottle do
    sha256 "496c7af8c0d99efd7b0c0a8c5876eb9dae4cc55026793e0a55510225e73a1d71" => :high_sierra
    sha256 "407f39365da527c4bfe390ea77756f8e1711bc5f97bb62c39c43a70ec1ea0409" => :sierra
    sha256 "765e2758490a45edc6b4145e2e22eb0e82c6cb43b877bcf439a2da13f9f55bcb" => :el_capitan
    sha256 "80af17509dd602b4f9e5c6c05add05b5a84337b20e231a05889c96776386ccdb" => :yosemite
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
