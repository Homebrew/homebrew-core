class Mdfried < Formula
  desc "Terminal markdown viewer"
  homepage "https://github.com/benjajaja/mdfried"
  url "https://github.com/benjajaja/mdfried/archive/refs/tags/v0.14.6.tar.gz"
  sha256 "cfabc77bff69b440cbc8909771f724c6c240e9b0f9787cb7c948d2d333fd8cf1"
  license "GPL-3.0-or-later"
  head "https://github.com/benjajaja/mdfried.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bac36d78f44fda65666e9e8d3286be3677c48bc277a996bad4a06a4a1ee46ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850f4ef4f8b058644e2da2e8a2a71b32618e089aceffe368b6563e3dc3dbfdb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c061cdd90833f334a1fe732154199ed6d2465d57dd48a0dc2b7c97831e6251e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e64b5ed143cee813c8b7f31a52283437d0939855973c3a6f03a075960113b34b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5b182a97bed382add9048d092abcda09af62f38f52b00af9776a314e4b4b71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba4328a89e4a82e7f1fcda56dbb8039ccb56b5c834f02aba0d31ba7e164a8121"
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

    output = shell_output("#{bin}/mdfried #{testpath}/test.md")
    assert_match "system fonts detected", output
  end
end
