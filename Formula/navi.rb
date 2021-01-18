class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/v2.14.0.tar.gz"
  sha256 "544c01e9d10dfcdcdded7758411e90d69e9b4734dfda1c0908359a72ba7b2bee"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "99e1a34a6147c99a220292285be053c1518cb8da78ffcfc3e5dc68fcac27c719" => :big_sur
    sha256 "7affb1cf4c22b2b68444a0db788c445c2b8c6d8dfea17d57adf65db1789af517" => :arm64_big_sur
    sha256 "4932e2fd37997f92a27a437d845220c9889cfbc432e200a269e286ec893b8394" => :catalina
    sha256 "f9b398bd630b0abdd40de61ca56048de57fc7fbafb1c58e0aef5002bd1e06b89" => :mojave
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
