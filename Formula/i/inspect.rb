class Inspect < Formula
  desc "Entity-level code review for Git using tree-sitter"
  homepage "https://github.com/Ataraxy-Labs/inspect"
  url "https://github.com/Ataraxy-Labs/inspect/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5ce60e6b8d5717a1ecb7ffc604a247452543e0adf8a8542c28848e27771fc0f7"
  license "FSL-1.1-ALv2"
  head "https://github.com/Ataraxy-Labs/inspect.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/inspect-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/inspect-mcp")
  end

  test do
    (testpath/"hello.py").write <<~PYTHON
      def greet():
          print("hello")

      def farewell():
          print("bye")
    PYTHON
    system "git", "init", testpath
    system "git", "-C", testpath, "add", "."
    system "git", "-C", testpath, "commit", "-m", "init"

    output = shell_output("#{bin}/inspect diff HEAD 2>&1")
    assert_match "entities changed", output
  end
end
