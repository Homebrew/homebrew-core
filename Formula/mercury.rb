class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.3.tar.gz"
  sha256 "d5b4b4b7b3a4a63a18731d97034b44f131bf589b6d1b10e8ebc4becef000d048"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]
  revision 1

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "825e3876f6c1960fb50fbe504af434e25578b3ff641353cb6f3254a098e2e5a1"
    sha256 cellar: :any,                 arm64_big_sur:  "2deff06f22ac96b29db1070ee830dafd610fe393e11e9cc53b48a88a7ee2ed24"
    sha256 cellar: :any,                 monterey:       "b6882729b695e6adfbc39625c0e6f08672c2e2a89611c46466b948a95323a91d"
    sha256 cellar: :any,                 big_sur:        "988660fd4e794c650aa9619db96b14f2aef5f41af103bb256f7bf060a41f9162"
    sha256 cellar: :any,                 catalina:       "4175cafa86fed2eab2ad5a910b8f8d6123ec1d82763a5a136ccfceeec7ee3805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe2e46ecc74258921fe2cd6e8e18b6561578517e6bfd261b603780306de17b9"
  end

  depends_on "openjdk"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "mercury_cv_is_littleender=yes" # Fix broken endianness detection
    system "make", "install", "PARALLEL=-j"

    # Remove batch files for windows.
    bin.glob("*.bat").map(&:unlink)
  end

  test do
    test_string = "Hello Homebrew\n"
    path = testpath/"hello.m"
    path.write <<~EOS
      :- module hello.
      :- interface.
      :- import_module io.
      :- pred main(io::di, io::uo) is det.
      :- implementation.
      main(IOState_in, IOState_out) :-
          io.write_string("#{test_string}", IOState_in, IOState_out).
    EOS

    system bin/"mmc", "-o", "hello_c", "hello"
    assert_predicate testpath/"hello_c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello_c")

    system bin/"mmc", "--grade", "java", "hello"
    assert_predicate testpath/"hello", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
