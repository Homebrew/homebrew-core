class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.19.tar.gz"
  sha256 "81ea1ac3de1ee3f7b50ad040e210408389049b38d7e8458f2dd0dbba6bf8825c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a75e885bf14966e09db9d0f94c731401a61d01c12e83917ee1897494fdfad26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc7a26e3ddf95a72a041b4aea1f9d1b5b16eff93b1b09bdac93c951c68e3a6c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d50027c805675775fb33447ad28e3b0728ef1bcb83d09cfc5e431cb6ff59ac90"
    sha256 cellar: :any_skip_relocation, ventura:        "df02eacdf7ac4699776fbf435dad225f27bd338a292aad5080c32b83810510d2"
    sha256 cellar: :any_skip_relocation, monterey:       "c91c05bcd32da3fe537fb1b83dbed34fb83c08756d315b05724a91594d0d2b95"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd68b6d1f0f87cc0965621baf4a74ce6151c20a0af018ff6ebc789453804a27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63810d24081ca225e4fd8ea8e2cc680e55d6a82e96501f4a694cca5769dc259"
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
