class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/refs/tags/ledit-2-06.tar.gz"
  version "2.06"
  sha256 "9fb4fe256ca9e878a0b47dfd43b4c64c6a3f089c9e76193b2db347f0d90855be"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^ledit[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("-", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb17134571471349a072e47eb5849e5ecc66006616fa77bf2363d04a8fa91446"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26e778db2994c1524b3b993e94eb642586c227cfe04b103e9ead54a557fa67ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9799ea6b0736a0a266eabd35ca40719683f4cb9dfecf220f4f73f3de26ee3b5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab446bc5a875dc4527f05103db24700488cc32761aa241d18065ac6a66082971"
    sha256 cellar: :any_skip_relocation, ventura:        "3b7c8d59ad0746dab63189ddc5fa9176b177c39404c368520be0cf03c9c14cca"
    sha256 cellar: :any_skip_relocation, monterey:       "6fd3e1bcddb9d283dd6dbb8b84bb0dcab8ee5ec215bef0004be1c2a4991c912a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3521f1fe5b11e11d11a53c988888cf4807db6f5f17e420010e5c85a543ce7211"
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlp-streams"
  depends_on "camlp5"
  depends_on "ocaml"

  # Backport Makefile fixes. Remove in the next release.
  patch do
    url "https://github.com/chetmurthy/ledit/commit/3dbd668d9c69aab5ccd61f6b906c14122ae3271d.patch?full_index=1"
    sha256 "f5aafe054a5daa97d311155931bc997f1065b20acfdf23211fbcbf1172fd7e97"
  end

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
    assert_predicate history, :exist?
    assert_equal "exit\n", history.read
  end
end
