class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/refs/tags/ledit-2-07.tar.gz"
  sha256 "0252dc8d3eb40ba20b6792f9d23b3a736b1b982b674a90efb913795f02225877"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^ledit[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "4409b258391836771d7b24c656e38cb5fbb5ae393cde9aacf410a44805c24af4"
    sha256                               arm64_sequoia: "4b19f4388acc0e7c77a6e3f3f74e897cc4a4de68c38d89c1aab6a39b2c1efe83"
    sha256                               arm64_sonoma:  "63df5cec4d9ad65c50543f76d1ba897282479bc12a2b60e1a65838362a04e48f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0aace47236bb34f7749c03df3c4b8dd97ffd7da4cdc2e2af3f8df99b1296804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e959fe2160d3fb329459c68a09204cbe888ef0bb6515fc644013de7cd414582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e959fe2160d3fb329459c68a09204cbe888ef0bb6515fc644013de7cd414582"
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
