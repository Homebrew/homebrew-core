class Mado < Formula
  desc "Fast Markdown linter written in Rust"
  homepage "https://github.com/akiomik/mado"
  url "https://github.com/akiomik/mado/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "e3de74feaea103e8348896f8e730cc9f6387fd18164e4ee9dffd32577f3d252c"
  license "Apache-2.0"
  head "https://github.com/akiomik/mado.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2878f9e31b04b6c35e4f69ec41beb2e872b4fb5428ab6eb41ec34052e9c069a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f7ff4b8449e74f5a30d96ed4ce6b636d7e43ce1415a0fb42e7bcd6e9f286bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6fe231ce35757d32ca89429c86965aa684cec1efc732bbb0a1abc62c273af8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b038cddd3df75f0667d8972510d0165624ca52dd3801704bfe75904c946d8648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff149549eaa270bb69e2a12ccbe166ea51c81bb795617e790cfed9552fd400ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07427ded660960c29167d3231314bdcb24baa4c721c4e7c8a58aae37e5fe8daf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mado --version")

    (testpath/"bad.md").write <<~MARKDOWN
      # Heading 1
      body without blank line
    MARKDOWN
    refute_empty shell_output("#{bin}/mado check #{testpath}/bad.md 2>&1", 1)

    (testpath/"good.md").write <<~MARKDOWN
      # Heading 1

      body with blank line
    MARKDOWN
    assert_match "All checks passed!", shell_output("#{bin}/mado check #{testpath}/good.md")
  end
end
