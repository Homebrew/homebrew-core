class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.14.0.tar.gz"
  sha256 "544c01e9d10dfcdcdded7758411e90d69e9b4734dfda1c0908359a72ba7b2bee"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "85d58e075944fcde015a3e45ed06668e64d72cd0b49afd5e719877da83863392" => :big_sur
    sha256 "d4d7330da91c8993867b2c2443cad374b07d063a1ea4587e404fe6b99705f83b" => :arm64_big_sur
    sha256 "2aa8fa7b3e54b886bcdec48fc5985ec0ad5f839f60e3ceeee385ba440277106b" => :catalina
    sha256 "b03eabbab9d70619bbbef6a6b97cf86f46cf6f64f3dca444ea7da818813693cb" => :mojave
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar",
        shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats --query foo --best-match")
  end
end
