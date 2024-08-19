class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.41.tar.gz"
  sha256 "fe6f8a234fee952e32057182fb9054e7d522193128121419556ec76f4be7bc42"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fb728c6036e4a861eeae17aca6ff127679731f4c167ffb5e0081be1602f4a26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "202bf7b9706ec7cd81a96597c71560b33917baf529bba21755ff51beee99e805"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65eaa6c55e1cb7f5ab835c88c763c6e181545c9381bcb6c9e0a36f2705952a4d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ac4d3cdeb714c68f7600f764f569aca1da26f0bbbe375583e899aa27f44003f"
    sha256 cellar: :any_skip_relocation, ventura:        "e2b2ef9623ebb0e21c017b51c6290c1128f4fa66e274b3fa9591a82ed45d767d"
    sha256 cellar: :any_skip_relocation, monterey:       "01e125adf46f375ec053642176495ed43644ac3d96520510e7df7b9030921a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7110082df968af933d0925d75d65fde7dccdf4032189d17fa7a4128c1d8fdaa3"
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
