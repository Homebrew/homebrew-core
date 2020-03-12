class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-20.01.1.tar.gz"
  sha256 "579cf00fa485d3918dbf9e50bb8057662b66fb82f69b3b824542e42a814bb76f"

  bottle do
    cellar :any
    sha256 "c6871399da6751d5407e22221a78e439d98b64c3826a2a98862561f013baa379" => :catalina
    sha256 "4735a23f1f6d8d1c9d828e37cb62068c459c922262ea20e8c6daac000d7cf268" => :mojave
    sha256 "e01491987cf0aaa54e733bc68b4f81ba02fbbfcff07c61b15b8224d31ed2b4b6" => :high_sierra
  end

  depends_on "openjdk"

  def install
    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}"]

    system "./configure", *args

    system "make", "install", "PARALLEL=-j"

    # Remove batch files for windows.
    rm Dir.glob("#{bin}/*.bat")
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

    system "#{bin}/mmc", "-o", "hello_c", "hello"
    assert_predicate testpath/"hello_c", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello_c")

    system "#{bin}/mmc", "--grade", "java", "hello"
    assert_predicate testpath/"hello", :exist?

    assert_equal test_string, shell_output("#{testpath}/hello")
  end
end
