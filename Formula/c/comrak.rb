class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://github.com/kivikakk/comrak"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "2321a3f9f23feae95402234fa02e71cad2a902583fdfa7097b7da0717fdad49b"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "458b7362de1e7569b17eadfc98e96c8a27ce45be410f0e15fd0d36999b21541d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "228413d6efaf04a404b29bfa3388e05822197cad6ee110c0e41aa9be8a4e7cf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74e5b89289339dd7901cca7001a359ca65c1391e6f5a9f32eceebf122845dc25"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1c079ec7302083e2b5afca320a11d74bba371f18c714f5a7b9d40ad43604d80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a35929fa19e3148c32fd4af8a02c08fa59af9b7f51ff4cb267e1c359b4c2fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82cff07791f5c57388f30d991d0055cf71cd1aa3ecd5f8eefa8acc8841b7835a"
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
