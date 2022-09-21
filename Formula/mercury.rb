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
    sha256 cellar: :any,                 arm64_monterey: "d4d7da746a3903308c29bdaf2a958a5fe2a8a39479b7915336189510daba2415"
    sha256 cellar: :any,                 arm64_big_sur:  "ff56525679c46110bb62e291836a5f41603346a3c907d7b6c95ca9d7d9200903"
    sha256 cellar: :any,                 monterey:       "3d8523d289526f717bcb3547492f5ab73b687b7fd93b8f93e123d993c5020f02"
    sha256 cellar: :any,                 big_sur:        "b655f38b5eab501a46de0681b8861a98eacd26b86561c46cc3b1c9ee09a682f4"
    sha256 cellar: :any,                 catalina:       "b28cfbfa350b95d12542948cb547bd9e93f23d9d9eb41c319e70e9eb7aa2f124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5adad7ca5952d6548e893639c131f6fa000fc6564d077f37df1b69398ea35093"
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
