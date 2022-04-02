class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.tar.gz"
  sha256 "14be3143302cfbb76383dac626e6bf64538c84748289595e6966319479775d47"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "529ee1af9b6aaf8a8173af8f2208007599ae96c6ef1275ddb03497181f6bb6d7"
    sha256 cellar: :any,                 big_sur:      "8b37f68829e59efd2127a32dfbcbf80d617196b6f35c970e1d4727b5076abb39"
    sha256 cellar: :any,                 catalina:     "2b98c59507d6aa72db55b8864d9818f302fef92b5bbdc6630287276494a3bc62"
    sha256 cellar: :any,                 mojave:       "e0011e25fa5732a2a271f30c5589c35f1caeb7cbab44ccba2271ab7bd2632243"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c1313fc019178406ba574ef1f9ffdf9b724a337e6831fc54b4a7aa68e02d2635"
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
