class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.5.tar.gz"
  sha256 "7e1b2d1b130c0afc65542be3c2e48399cf2c25d7a04ad3c427e022715b098a0f"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a5db345a7f91984e9453a5eb0ecf8dd607fb94b9a0c223fc468c24de1900d831"
    sha256 cellar: :any,                 arm64_monterey: "dba557568c01b9133e3468ca27b9a1b64087a21345bc61b1c060e8999f1dc105"
    sha256 cellar: :any,                 arm64_big_sur:  "ad6fcd4d465d6633392227ea1388d7f7d37df2d51f5f20657b919fa1f8823d9c"
    sha256 cellar: :any,                 ventura:        "1dcbd0c77ec09e80866a9d28152901b09b9d77bad76926866aac70b83c9e950c"
    sha256 cellar: :any,                 monterey:       "007f5a1b58e2c6033e3300b0f8241a60de14a63e4c26eba650e823dd59f465e7"
    sha256 cellar: :any,                 big_sur:        "877d19a286015dcf5ea72d8633022ff83ffe7662b1ced07cdede3d751b7f0fc4"
    sha256 cellar: :any,                 catalina:       "a294e12fed0a1752bac9f139f47dfe2676dfb871123a32bd03a3fad000a4d52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bd92d59afaeb95687bdf12756bf69ca7438ae153b05467961ef789f38aeb941"
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
