class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/refs/tags/2.08.tar.gz"
  sha256 "0f10f70bcdde68ce6514d4eedeb0774653322385a642d1ee696438b5594050f1"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^(?:ledit[._-])?v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256                               arm64_golden_gate: "991855179eac253440d7e9286c46839ea9ce0fea6475ee1a9462120a14ab14ab"
    sha256                               arm64_tahoe:       "4588fe36e65c0dc2aceac049ce08b4896dbc68c3937894f973c9b3302efd7400"
    sha256                               arm64_sequoia:     "d5591770d02fd1dbd69441274604e91269742865c2ac64dedeb95cd3f8cdabc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "35264e3ace14f2b900d145b92577cc47ae4ae4208ba1cf01e6e2b1ed4618153e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "35264e3ace14f2b900d145b92577cc47ae4ae4208ba1cf01e6e2b1ed4618153e"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlp-streams"
  depends_on "camlp5"
  depends_on "ocaml"

  deny_network_access!

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
