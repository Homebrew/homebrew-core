class Md2pdf < Formula
  desc "CLI utility that generates PDF from Markdown"
  homepage "https://github.com/solworktech/md2pdf"
  url "https://github.com/solworktech/md2pdf/archive/refs/tags/v2.2.23.tar.gz"
  sha256 "ceddde22e16d70b018919759fbc393f91accacea748bcd3469f840535e33bd86"
  license "MIT"
  head "https://github.com/solworktech/md2pdf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4dd7e9bb5330f38c08accb0af6d1afd11ab753d0e8a0cae06f8605a7d538d3b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4dd7e9bb5330f38c08accb0af6d1afd11ab753d0e8a0cae06f8605a7d538d3b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4dd7e9bb5330f38c08accb0af6d1afd11ab753d0e8a0cae06f8605a7d538d3b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "59d4b2d8aa59b8ab7306209dd045cf3453c7c3918dc610b405a7ecd223c2e4ce"
    sha256 cellar: :any,                 x86_64_linux:      "87e2913caf7e4dbac30503bed462b198a54c8f4516fcf22860f672fc8ef618ff"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/md2pdf"
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Hello World
      This is a test markdown file.
    MARKDOWN

    system bin/"md2pdf", "-i", "test.md", "-o", "test.pdf"
    assert_path_exists testpath/"test.pdf"
  end
end
