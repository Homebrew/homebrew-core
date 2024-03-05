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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8c0342f471fe4420da8922a3bfb1543c6831888c3464d2bd656114f5d203309"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "546a6695af08a56774657572ab570fbecb73c8234196f80cdeeab276633fe30d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4ab8847235ecca039bc55d8b5774569fbf403a448d071e118a137596431abab"
    sha256 cellar: :any_skip_relocation, sonoma:         "2094540782b4257259e4d52319b08b52cd370371804b2a130f3cb4ec37cae351"
    sha256 cellar: :any_skip_relocation, ventura:        "c2d88c9bf6950683d344702af7289d0ed83b73b88865be6af415deda875ba55c"
    sha256 cellar: :any_skip_relocation, monterey:       "012ffc2e72e5c7d9bc10fa6fd533b54ab0e48388b6fd1f5618541916ae97df19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a15d788d892d4f3908a699499878024aefe878da85077b105b6798e291ba645"
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
