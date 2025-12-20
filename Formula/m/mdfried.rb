class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "52c4a793172899469780c63350dd32745b8421076277c07f4a382973fd049797"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da244c21fb093f10b1222be2887db590100c059bdb10d4de8d99999fc7e00ed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd92127b7d739728820c7ec8cd5bc3c4143a44f0db182cebefcfb73d5e5c151f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73bd75e2862b754df570beac579d3bab3db6ce6f841c7dc0e4f303b53a44039c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dbf7b7786b446efd7713a14c28703946e19db79e0b286056328d1b14c377656"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ea1418c70ba4fc24ccea040c110e7491653a9de44840806ce54c5fa0ed42332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1b416858ee03e2301f97a1e4e08fb7de6b84e781184846be65a21909937fab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdfried --version")

    # IO error: `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
    MARKDOWN

    output = shell_output("#{bin}/mdfried #{testpath}/test.md 2>&1")
    assert_match "cursor position could not be read", output
  end
end
