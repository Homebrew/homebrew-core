class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/refs/tags/2.08.tar.gz"
  sha256 "0f10f70bcdde68ce6514d4eedeb0774653322385a642d1ee696438b5594050f1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^(?:ledit[._-])?v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256                               arm64_golden_gate: "4d9be2b4f721cbba9b6ad2d14f10262539d74766c7e4a097605c031efee81b04"
    sha256                               arm64_tahoe:       "17679f5216e8689bd781e33abcb408f27880e578275feadd966868a12a2829a9"
    sha256                               arm64_sequoia:     "83b1292aa5da89a37a2fa0735d23569ee01c40cc88de3c802989c502478603dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "837f200c1b5d0b4adba5468d8d2a9f5c57c08a3470cc156e4c4f10bb00c3abdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "837f200c1b5d0b4adba5468d8d2a9f5c57c08a3470cc156e4c4f10bb00c3abdc"
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
