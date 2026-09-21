class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.9.tar.gz"
  sha256 "582639d89530dd6539c3af01b841f682e6554c3ca5c09be124e789d7ca4b2b58"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2698cb69ac9bf9786ba9f25a61f5de63eba242b86cba4107f3bd791b8f39aa3f"
    sha256 cellar: :any, arm64_tahoe:       "9a59215c8b16c6f76e8c1005c2d0899cc0984a7f483ab28a7dc68dfcbfad1041"
    sha256 cellar: :any, arm64_sequoia:     "798cf10980de0d9095a9b1de3911c18d1156d0ecce3b2610b07bd577ca2904a3"
    sha256 cellar: :any, arm64_sonoma:      "3c6f02a50174f06cbf17561a64d19bc561eb93138e45ba5ea91682d68a331175"
    sha256 cellar: :any, arm64_linux:       "8ee061dd2ae504a4c7d5f5edab861e44c405d8a58e0af4c9c6981327bd9884e0"
    sha256 cellar: :any, x86_64_linux:      "b1a18dcc2405e9ad82d08dc848602a10487b4996d876471b1b71b43786eec1e9"
  end

  depends_on "openjdk"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libedit"

  def install
    args = %w[--without-readline --with-editline]
    system "./configure", *args, *std_configure_args
    system "make", "install", "PARALLEL=-j#{ENV.make_jobs}"

    # Remove batch files for windows.
    bin.glob("*.bat").map(&:unlink)
  end

  test do
    test_string = "Hello Homebrew\n"
    (testpath/"hello.m").write <<~MERCURY
      :- module hello.
      :- interface.
      :- import_module io.
      :- pred main(io::di, io::uo) is det.
      :- implementation.
      main(IOState_in, IOState_out) :-
          io.write_string("#{test_string}", IOState_in, IOState_out).
    MERCURY

    system bin/"mmc", "-o", "hello_c", "hello"
    assert_equal test_string, shell_output("./hello_c")

    system bin/"mmc", "--grade", "java", "hello"
    assert_equal test_string, shell_output("./hello")
  end
end
