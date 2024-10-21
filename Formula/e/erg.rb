class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.46.tar.gz"
  sha256 "f9f81267dad4f145b3faafe258441cb8673619fe03f1464361385ac244e1df85"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da109e97bec9a6bff90f28abefbcd14e4994a9dd66f44b6803c817514eeb8d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d378af424b80ac709175eb19bea04ae3c131b272ce055eee777e4b149131adf2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a3996fc1dca03680ad8866f1c9a130746e8b3d6c9ac994a080e0747e48e4237"
    sha256 cellar: :any_skip_relocation, sonoma:        "1454eba3de6381e115b1583357b31b293156a1a1f6603a8c8e70cf8d58fb8994"
    sha256 cellar: :any_skip_relocation, ventura:       "869eeb0a22dbfbba941598cdc4051f1caae368c903ce0e5c79e4a3e6450f2e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06119fa93aed6276e51d5453ccc8bf74f049761f6ab5bca7d304ade28369c6dc"
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
