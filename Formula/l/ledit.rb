class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "https://pauillac.inria.fr/~ddr/ledit/"
  url "https://github.com/chetmurthy/ledit/archive/refs/tags/ledit-2-07.tar.gz"
  sha256 "0252dc8d3eb40ba20b6792f9d23b3a736b1b982b674a90efb913795f02225877"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^ledit[._-]v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256                               arm64_sequoia: "a1c09fdb10ac873836f1f3370f77f8d87f9db7adb3ff0118ac0ba97b96cdb15e"
    sha256                               arm64_sonoma:  "6659da41bcf927019dbd40f4e9c201e964ad63fae3dd19a1425313f3b51672ad"
    sha256                               arm64_ventura: "62f4ceec2f8e79b0be37a14ffa16ae6741722cb0bb0868d5aac2d12988b5c6bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "59699dfa06f09eb79a2fd6b500757c7384b27d73cc44f2e5d05c30bc122cb9d5"
    sha256 cellar: :any_skip_relocation, ventura:       "6db3815932944204f44ab9e31bd34a678c8fc81d92c3b86e5518fc1bc8cffbcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd2c6e9eb1c5672a81399729bdaa9700876b024c24fd74bc982424790d9d2c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd2c6e9eb1c5672a81399729bdaa9700876b024c24fd74bc982424790d9d2c01"
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
