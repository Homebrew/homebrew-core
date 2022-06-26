class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.2.tar.gz"
  sha256 "a8f92f5b916c2a333101bcad2e2c405a527b8c4ec7fdd1cfd973f9f4f6ab17e8"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b195074f59ae3d78ed191c698294f46d79d97f3abd2a5f2aa42e2f79ae29d16c"
    sha256 cellar: :any,                 arm64_big_sur:  "d0d93983ca4e7a235b746d522cf780c558d5b96d5735dcfeb9e0100cc96f78ef"
    sha256 cellar: :any,                 monterey:       "027211fa6f95af6d93b5bc410c90fa51e21d049db5cac8265edff024fe1731d2"
    sha256 cellar: :any,                 big_sur:        "46085c1e7a2827170b8409ab7197af0fe9c32f776adaff1bfccab2b339cb11a9"
    sha256 cellar: :any,                 catalina:       "eb449cffa5f41ac6884a0d00f6245a65594b0439e57ffdb67a2328d27271318c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c9aa159fa04ea34c3266bf53a567a549964223672b5e30f5842cb23ab18a2e"
  end

  depends_on "openjdk"

  uses_from_macos "flex"

  def install
    system "./configure", "--prefix=#{prefix}",
            "--mandir=#{man}",
            "--infodir=#{info}",
            "mercury_cv_is_littleender=yes" # Fix broken endianness detection

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
