class Navi < Formula
  desc "Interactive cheatsheet tool for the command-line"
  homepage "https://github.com/denisidoro/navi"
  url "https://github.com/denisidoro/navi/archive/refs/tags/v2.24.0.tar.gz"
  sha256 "4c10f47c306826255b07483b7e94eed8ffc1401555c52434a56246295d3f2728"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3ff7e21fcfa5d67d3f1a241c072dae09d25e53db64b17b08f32ea31af16ac5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1e8788887b0af9311ae2ec08e2e8b79f2c8eb956fe83c6a626428bd8f31ca52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe900be26fc0611571f6f0234a051cea807be33f790ca5bfad20fee7f216111f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c7f7bc05db098687b6f96f31999913ef40940ddf1261e01be3f42ab0dfb4bad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a4116fe87ca4f2a1854f6f0a00d693f3a6a4269b4d6e534d9e4a4f9d71d7f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e26d0fbed48d505f515974efeeeee05b93e073d8b3b6241068432720fb3b6e59"
  end

  depends_on "rust" => :build
  depends_on "fzf"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
