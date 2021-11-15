class IcarusVerilog < Formula
  desc "Verilog simulation and synthesis tool"
  homepage "http://iverilog.icarus.com/"
  url "https://github.com/steveicarus/iverilog/archive/v11_0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/i/iverilog/iverilog_11.0.orig.tar.gz"
  sha256 "6327fb900e66b46803d928b7ca439409a0dc32731d82143b20387be0833f1c95"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/steveicarus/iverilog.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "2ac5133198143cad8b5b04e6eabc60b0e5d9b124881b2d07531c7a4fa1e1eab3"
    sha256 arm64_big_sur:  "8c5b344e8564ddd8834922e65bb6ed4fd3951bfdbab3a80064cb8a40f53fc643"
    sha256 monterey:       "e7fc5ea4149ccff8b4187eab05be448d1b1cc1f5ece057e9c441d8f3882390a4"
    sha256 big_sur:        "e4f89cc6c8f66d90e45af4357c496ec2ba49ea48ca04e552ca318ff31e825489"
    sha256 catalina:       "99791a3fd0891487586c49112fa3293e65320e651bbf9c03f15a58b456e96e6e"
    sha256 mojave:         "92851adfb43caad0826da2bf74706c15e6fffc2e32b2b003e19659b0e6a4542b"
    sha256 high_sierra:    "a92f6fe981238a8c2b9f47b99d77c1e8596bc74235b8f6601835aae8f9ad70a1"
    sha256 x86_64_linux:   "edee1d331189156e7929b50aa7c7515ad15e8721650d936028905aade9e8fccb"
  end

  # support for autoconf >= 2.70 was added after the current release
  # switch to `autoconf` in the next release
  # ref: https://github.com/steveicarus/iverilog/commit/4b3e1099e5517333dd690ba948bce1236466a395
  depends_on "autoconf@2.69" => :build
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
