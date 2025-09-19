class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "bebab6c48035361fd5ec4aaaa14f5d48029c450fe51e0528890b051f624448bc"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f3930e4dbf853f7f0b76cc17779347b3122e4383cc1a8939689893fa076f038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f02d2d6913b6509e6d2b7b3f9c54454028287cd0a5060aa82a54789665985668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b940b1b2e726096a60b390f7e2fa0f288b57e1bbaa40d9c1ad1c36235b05f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6baa19401154f69b54e5a34be0313039695b2d9a5cabc4fb6bac3d83ab239c28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fd6a408bd422b6ceb85b5a083b01eed626fc6e7a573f072a4268ce2a6dc111a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "838f7f5d93db4fea51f12f8b91aaa9294a722e0fe7e01c8e6b8bf2ed5b5f07a5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end
