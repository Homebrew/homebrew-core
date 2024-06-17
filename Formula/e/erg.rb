class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.38.tar.gz"
  sha256 "158012b3eb0ff38dbf3996d9f78cfa46779ba7029e31447bc751843257e5ed8c"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52a1837274869dd5dd95c352e28a214734b0a8cf1e1ce79667f862dd8ec19f80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7bdfc3b9b40a7f15cf0cc871d2f86dc714127567b5fb1392a7e78215075006e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a010c5893401cb94a0674c008f1e6bc068cd6484ea90c2de787f238a2d6ffb2c"
    sha256 cellar: :any_skip_relocation, sonoma:         "508f012db07f64c31a680e0cdec65320ed5bdba7fc346609ace11aead1309d5a"
    sha256 cellar: :any_skip_relocation, ventura:        "0ff7c12bebeb82846e6ae072d9f05b5a7b703985883c99d34698a5bad6cb15f8"
    sha256 cellar: :any_skip_relocation, monterey:       "a869effb57f29497edf7d8e513aa972ebb69ac5dcd40789144d9665ac530a67e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5dfcd9e263bf6aa7e36a0450641071a9e80872611c7ae21db7e252d2fe3f0cf"
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
