class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "9733570d64a1eafcf96fe233fd978ec3855c77705005037ad253c49a188fdf51"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed63f0adae5d3673f2c54da07bc9ae94395479b8700e4ec563a4a8c636ba910a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7aafd128970ea77dc23c09a7dfacad1834b01defd745369f7d11549d2ca0055"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "591fad4f9045788a5980abc136b8b04b689468789406e19c2339a1934526fc6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f53f2f55b9c2afb08399342293ac242f89dcec9a7a3225bfb1d46a8e85eb799"
    sha256 cellar: :any_skip_relocation, ventura:       "f7635f25cb2e68fb7ffa652c3d4bd87343e9190ff0aba65ff92eee63fd427e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e19dac5a9475d48331eedf63009da2d88c04a66a1bfd6118f60eb1cb149fc97"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/diskus.1"
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match "4096", output
  end
end
