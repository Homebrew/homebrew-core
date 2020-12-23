class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.13.1.tar.gz"
  sha256 "5f130829bcfce96da8acfee943e2368625b26d83fb391d2f6409acd47923a342"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a94ea1dcff5e8b1cbb0592c5819a7fd00abe6107d08cb1fea13b8af8a42ff465" => :big_sur
    sha256 "3740e04566dd7ce662e03a23365f46613f0d41c3637f0887c1044e596d018da6" => :catalina
    sha256 "c7c23013821b2a5c3e4f435ae98a90f7f228f1b61f96f867bf40de7dfe291ef8" => :mojave
  end

  depends_on "rust" => :build
  depends_on "fzf"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "navi " + version, shell_output("#{bin}/navi --version")
    (testpath/"cheats/test.cheat").write "% test\n\n# foo\necho bar\n\n# lorem\necho ipsum\n"
    assert_match "bar", shell_output("export RUST_BACKTRACE=1; #{bin}/navi --path #{testpath}/cheats best foo")
  end
end
