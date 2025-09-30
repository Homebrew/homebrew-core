class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/refs/tags/ledit-2-07.tar.gz"
  sha256 "0252dc8d3eb40ba20b6792f9d23b3a736b1b982b674a90efb913795f02225877"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^ledit[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256                               arm64_tahoe:   "43b80195f585913bed776d670edba2de09548bae5b4bd0c025b9d9288490f1fa"
    sha256                               arm64_sequoia: "653f7b3a2c1e9e43277cd71a1372411055cffdb00c117338b7bad7a25f46105d"
    sha256                               arm64_sonoma:  "561049e6938a5ea683f00cdfba159504b442c45f2d81ff2daf0dea68ac9ce92b"
    sha256                               arm64_ventura: "00a97eb38296ecdd8477456b8e8d584c6c6798bab6075fe3188058d95636d1a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6de3036421e83e22dd080005616d42109671979947a7408428871a7a51e6239"
    sha256 cellar: :any_skip_relocation, ventura:       "be5d93d43d670cf829f83b8540811d701a7eba2310a0c49b75b0349ff160ddbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa138a11a2f7d147c880e4075da50d042f01f53587356384430e6610f2473eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa138a11a2f7d147c880e4075da50d042f01f53587356384430e6610f2473eb0"
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
