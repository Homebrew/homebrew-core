class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.51.tar.gz"
  sha256 "14ebc95c0f3fb072878dab89308decc8796bfc9ba30c7c385e7f68dbee1d9289"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9c3c41c14b8abd71ec14bba88a0bd7dcc5e827e77631256dbe56940a4619b4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deafecf5d45cf0d53005f58aaca0f453227070fc325e4634789092e441f1a928"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4a0d82fbe761b12f52f441532be19f4f8b85c0740e627b56aeaf2fc773e9c92"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ffcf01182169733c8aee8fa20ca775a2615d5636f6c89cdcd2bd7f8862df82f"
    sha256 cellar: :any_skip_relocation, ventura:       "117f3328858c2b996cf69ea47701bde70a3bc3eb937200d61b6e6f3d03685975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "528c32d0503a42313d0ae7fc7dfb7187edb534407d9742a31c3db70bb1c9f211"
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
