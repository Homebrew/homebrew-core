class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/refs/tags/ledit-2-06.tar.gz"
  version "2.06"
  sha256 "9fb4fe256ca9e878a0b47dfd43b4c64c6a3f089c9e76193b2db347f0d90855be"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "61f6cf0c9da96da6a98fc8898d48afb33c27c001359be6ad1fe30a3aef9f164a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cd73d8f31cd78874d997a6d4fd9f641e48feca0f7fe8563bb76bc1cb3e54fbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3a9793e08a678bf56e0d52ec6d1882a7e9f315b3aa3408444ed140f15bf2b32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8fa06836756c84e6f20a13214680bbb0b360025ef193211d7e3ac0b88856202"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba5e850a2325c803b48366814ccd65ccf4acf57112f9cb16b4bc5ef43add3a8a"
    sha256 cellar: :any_skip_relocation, ventura:        "61b71950ed308177659d6d98f88e83d9f26b2ce8c9f41cffab9e92eef9988144"
    sha256 cellar: :any_skip_relocation, monterey:       "482dd44cabb6afec89846ad02430f0b48e2aee3e32885c58eedd38619fdc4886"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f97323d9419ce17f3a5f3cf7586966484c7e073186588f7a9b86a7219749915d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "280c140f1337f33186cc2d9a1946cd27732435292e98fff8c1a431d408ebb237"
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
    assert_path_exists history
    assert_equal "exit\n", history.read
  end
end
