class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://github.com/erg-lang/erg/archive/refs/tags/v0.6.28.tar.gz"
  sha256 "fa884b432278ee69d9fd077b53813224db42eae409da15c00deca1899d4d3a59"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc9d148672cc7d669fbe229f57ff69bf453a33e92cb462c4ce23ba8cc58688b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b96f15e19066403e1ad68e9dc27e614179b180aee0e272adb9c9d1a71fdc8df6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1bd40f7d2d32b63915516163c633f9dc942af383f3d9e75dade3266de1d8474"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4b6c82b0e154a1865d6f575c75e4dbd37b5def7038fdd5a77fadce1441fdc33"
    sha256 cellar: :any_skip_relocation, ventura:        "6f99e9ab9784669ab1b24aedb6ba84277fe4f632dbd3afd77b728b59dfd6c245"
    sha256 cellar: :any_skip_relocation, monterey:       "286d1a03b7b60b5800938f6bdbf0bb42fba0d18fff1dd2feaf6270806a8264bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11306d6dda68c9c8316d7dc599dc610d8d995cefd0bd72a0cc9a9ad888a44301"
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
