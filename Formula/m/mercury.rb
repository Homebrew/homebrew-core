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
    rebuild 2
    sha256 cellar: :any, arm64_tahoe:   "8c3f6e6288f050e8777b0d29a263ca794a116ebbfcbf6e807ea06b73bea12762"
    sha256 cellar: :any, arm64_sequoia: "71035c5c5b2af65cb83f15fd9564ef08f6a0c0f5b36fd7ef57ec46a63576e0eb"
    sha256 cellar: :any, arm64_sonoma:  "821662765b1e006d3d7419df9561bfdbe4c45dd9113a32fac890a7e9d5242dc9"
    sha256 cellar: :any, sonoma:        "bb0a5dfecf2845b8fa357e7385a640d397eb56468b8640873f9c5124d1e1a6de"
    sha256 cellar: :any, arm64_linux:   "24e58d3aa2d474517e4ac55ef639813e28f164e9c9ae392dd760a4ee065c103e"
    sha256 cellar: :any, x86_64_linux:  "2f928bdd6edb6e25578e950fe92df676abc86ab81b6028dfa10bb9b6008dc748"
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
