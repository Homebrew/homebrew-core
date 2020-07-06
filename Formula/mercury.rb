class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-20.06.tar.gz"
  sha256 "b9c6965d41af49b4218d2444440c4860630d6f50c18dc6f1f4f8374d114f79be"

  bottle do
    cellar :any
    sha256 "8a643b7f50072e004089659525f9e08b05fdecbc031db32d591dbd4aa1fa110d" => :catalina
    sha256 "f343d99ebc86c3eecff969e744fbea6e90400884650781bda85984978dfb6848" => :mojave
    sha256 "6ec1305a6b2c81e8bc0c8c57aaeeace93a600e01913794d83ac3420c69959456" => :high_sierra
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
