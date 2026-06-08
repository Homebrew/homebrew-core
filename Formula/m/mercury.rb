class Mercury < Formula
  desc "Logic/functional programming language"
  homepage "https://mercurylang.org/"
  url "https://dl.mercurylang.org/release/mercury-srcdist-22.01.8.tar.gz"
  sha256 "a097e8cc8eca0152ed9527c1caf73e5c9c83f6ada1d313a25b80fe79072fbad8"
  license all_of: ["GPL-2.0-only", "LGPL-2.0-only", "MIT"]
  revision 1

  livecheck do
    url "https://dl.mercurylang.org/"
    regex(/href=.*?mercury-srcdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b4d0ab2e114dd28fb1b95c62bcd8401d6ef95195c2f5a74e89da28a1c55f275c"
    sha256 cellar: :any,                 arm64_sequoia: "db876431b91d903991be29e49819963b3820ddf1312f72569b6e9c18f3f99cab"
    sha256 cellar: :any,                 arm64_sonoma:  "41623c085798cc8cf269f9755d6c5b2848f5f3d141e9c826a657f97a4e4b2b5d"
    sha256 cellar: :any,                 sonoma:        "499aa73ce989569c399b672e485f15d48362c395b71808f0bf1f490ff5b54a22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e90c695b191f860473f6042587dc25c8f85c0cfa3d79f00f43992a7a9e0b52a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5627e4fcb8f3fa0b0926ba97b0e3f5a868a06d856870b8ba6ad4e383254e8c68"
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
