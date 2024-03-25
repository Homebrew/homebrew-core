class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.20.1.tar.gz"
  sha256 "1ead3ba79bacec1065c5c035e4adbd1597d9ae6ea42642aa7a21c3b2bd9fb786"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "581c0681cc49ec113bea7af0e51edba296c6fb3ea48ee46abbd702303465e0e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe86d8e642ca15968590983b7072846503c071ee5b9bc05cc755894ee125d59f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "217f56d69ab9d1222eac328534401c83772013ce1f0ec27f0f311741dddcbffa"
    sha256 cellar: :any_skip_relocation, sonoma:         "752727497a3913ae103930aecd5d12423bb5b7bc32adb178b614832bb9298aeb"
    sha256 cellar: :any_skip_relocation, ventura:        "4697db8193b3acc645e83ab8dc45b592ff4d4ae21ae5e68da47687aa1f3dff4f"
    sha256 cellar: :any_skip_relocation, monterey:       "55b1947601c8e99549f41d4cfe02c641c32a6af321f553f20eef8a1d9b2fe1f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac728601c7cf1f19be7b4481ce5a2348173ca0c5ca268d4afa4ee68984f4787b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end
