class Doxx < Formula
  desc "Terminal document viewer for .docx files"
  homepage "https://github.com/bgreenwell/doxx"
  url "https://github.com/bgreenwell/doxx/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "3627e65f39e437d954e1d4f02c30911fef1c5c99388bf6098564e1e89722e80d"
  license "MIT"
  head "https://github.com/bgreenwell/doxx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74d4459038beac34f058430c6989791384f2eaba6c256795bf4d9b29c491898f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde2050546c17f2d57df8e6049d872e2550df1939b1248244a6ce5a927e254fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "441aefb5e628bac7267beebd1b46b33dd5aefb5e275857b25bbdeccc9f2abca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf34c611bbcc29e096312963252fd2089794b69ed19a5f6b94fc78cc01526099"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2535f0667b90ab6e9000a1fdbab39c30c1d20caefca51f2dde257b1fabfed196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c9e40fbf75a99b5e5ce1f77714445f771553291f6d05c42f9d1d219a441afd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"generate_test_docs"
    assert_path_exists testpath/"tests/fixtures/minimal.docx"

    output = shell_output("#{bin}/doxx #{testpath}/tests/fixtures/minimal.docx")
    assert_match <<~EOS, output
      Document: minimal
      Pages: 1
      Words: 26
    EOS
  end
end
