class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/refs/tags/ledit-2-07.tar.gz"
  sha256 "0252dc8d3eb40ba20b6792f9d23b3a736b1b982b674a90efb913795f02225877"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^ledit[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "0fe88c4c03d6f9d38e2b230ecf971637752d04a927d710cfc8e62e8f9b0dd899"
    sha256                               arm64_sequoia: "710dc116b1f5858005b3b135313ecd8c156ae196d0e3107877f31ef226ef11d9"
    sha256                               arm64_sonoma:  "7f8f6e093464dc08dd0d0066ddd1c1297ca5028ed1a00d24d0781615323572a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6443e3f4a7374c9fbb06bc37c792739d9abdc6762ad7607eac74c8ea28f3c158"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed4115e5c24dd1325cb8c5106f59b4aaa6a719a9e719a5ce0437a273b752ca3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed4115e5c24dd1325cb8c5106f59b4aaa6a719a9e719a5ce0437a273b752ca3c"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlp-streams"
  depends_on "camlp5"
  depends_on "ocaml"

  def install
    # Work around for https://github.com/Homebrew/homebrew-test-bot/issues/805
    if ENV["HOMEBREW_GITHUB_ACTIONS"] && !(Formula["ocaml-findlib"].etc/"findlib.conf").exist?
      ENV["OCAMLFIND_CONF"] = Formula["ocaml-findlib"].opt_libexec/"findlib.conf"
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
