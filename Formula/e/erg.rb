class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.32.tar.gz"
  sha256 "ed84e92f56f778ef8477b62e091dd4e7b3cb1bd69b6e385a13830036795b1146"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2441710b619f2a758e6c560f0d51e90b292cbf6441b964d6d0ebd6e0e2d34aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "311ed525d1ca18430f59124be3d0eb016297936b2b23f7c33dadaec2329d6a42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c243b8c8bfc153d7f120d26e86a8d0a2be33cdd19c7c5ebd995f991d231da16c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fcb359ca828329c9c7599022c456012baf58ec81ff1c34fc18293f1df84f916"
    sha256 cellar: :any_skip_relocation, ventura:        "dcbf8ef6b6bc660474487895d36ffdcfcd07b8e148922c111d04bf4762b3d359"
    sha256 cellar: :any_skip_relocation, monterey:       "ebf6f3d0da7ab873f48d05814144651dc451632241613659992961ba7ac2b27d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbfc797d79287f55fa49339adfc10a17a6ee77b7d22cbded08c79af5bfa6f989"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    feature_args = "els,full-repl,unicode,backtrace"
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", "--features", *feature_args, *std_cargo_args(root: libexec)
    pkgshare.install buildpath.glob(".erg/*")
    (bin/"erg").write_env_script(libexec/"bin"/"erg", ERG_PATH: pkgshare)
  end

  test do
    (testpath/"test.er").write <<~EOS
      print! "hello"
    EOS

    output = shell_output("#{bin}/erg lex #{testpath}/test.er")
    assert_equal "[Symbol print!, StrLit \"hello\", Newline \\n, EOF \u0000]\n", output

    output = shell_output("#{bin}/erg check #{testpath}/test.er")
    assert_match "\"hello\" (: {\"hello\"})", output

    assert_match version.to_s, shell_output("#{bin}/erg --version")
  end
end
