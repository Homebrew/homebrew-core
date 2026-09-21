class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/refs/tags/ledit-2-07.tar.gz"
  sha256 "0252dc8d3eb40ba20b6792f9d23b3a736b1b982b674a90efb913795f02225877"
  license "BSD-3-Clause"
  revision 4

  livecheck do
    url :stable
    regex(/^ledit[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256                               arm64_golden_gate: "09936a19fd839c942fc87d955b692aecfe37e5ff56b4050b6571feca111d609d"
    sha256                               arm64_tahoe:       "5436407da729171a830263530217b8bfd7997c38bd7e8a6d42e8120cf54296d4"
    sha256                               arm64_sequoia:     "f7676f12ed17e6ecbdd5f134d28027b86ce9fd50e17faa1280ba6b5f4d5c6ab6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce83484af144e1162b1f91c81432466fdebc27b5a5788fd798dfa1e0a0f1cf39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ce83484af144e1162b1f91c81432466fdebc27b5a5788fd798dfa1e0a0f1cf39"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlp-streams"
  depends_on "camlp5"
  depends_on "ocaml"

  def install
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = formula_opt_libexec("ocaml-findlib")/"findlib.conf"
    end

    # like camlp5, this build fails if the jobs are parallelized
    ENV.deparallelize
    args = %W[BINDIR=#{bin} LIBDIR=#{lib} MANDIR=#{man1}]
    args << "CUSTOM=" if OS.linux? # Work around brew corrupting appended bytecode
    system "make", *args
    system "make", "install", *args
  end

  test do
    history = testpath/"history"
    pipe_output("#{bin}/ledit -x -h #{history} bash", "exit\n", 0)
    assert_path_exists history
    assert_equal "exit\n", history.read
  end
end
