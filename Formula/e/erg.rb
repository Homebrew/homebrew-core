class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.22.tar.gz"
  sha256 "d85687ddf8b319fbe505190a6339208b9a0dbd1d8a0780d50cfee40dc49b137a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5e47665b11ee064983e18bed4745d7ecaf3b9443b86c91915949bc98a43ac96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5624d0e9878835df471614ec87ae15f4189bf81b4157a6bb5d6fda5dff69edf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfa36fea249b17ef9b46c1321c2e7e0e3304f136a1574e2d876f00096b318f3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "afb2360357c46b57352210cd2602f89afdf3a1f1aabf9d328c2ba9a85269de61"
    sha256 cellar: :any_skip_relocation, ventura:        "c49d223edd5009a64e50b07d24ceff87a97210c7976dfa4e3521f6eb3eae4943"
    sha256 cellar: :any_skip_relocation, monterey:       "383bff7d09d04699ecd78fff94bb49a7396e3267253f815c88456a19647157bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2cdacd907772022f673167751e86b444ebe0065cdd3d6dda9dd4fedb58810d0"
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
