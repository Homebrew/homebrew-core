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
    sha256 cellar: :any,                 arm64_monterey: "76fcb04ba5fba9d885507c94990f789ca950a6e6a93ad596d655c2199d2948c8"
    sha256 cellar: :any,                 arm64_big_sur:  "b12f80db4a11322fc044536edff7095cfd4e94d8ed91f19a8382615b4eacc807"
    sha256 cellar: :any,                 monterey:       "763f8438ef99e04bad64656d85d3be25e1812a480a50e854693ee2da1122d0ba"
    sha256 cellar: :any,                 big_sur:        "f70d8e3ea7a28db2a1901b68d37823a95122dcfcd2e1aa9af4308282917c9825"
    sha256 cellar: :any,                 catalina:       "e77241122d3fccfe0e2472e02c84144b9d9bd8382f61410c2a7386eda7d683d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3abeb27e5e7a325f1a9ae2705d6d1b2a354e963b4d955fdf1491b473c1c7b733"
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
