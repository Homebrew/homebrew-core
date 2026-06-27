class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.24.2.tar.gz"
  sha256 "62687c0a84ceec76d17e30e494dcf8e65c7099a2e24a6a521a41854b8eb3759d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8128df40ab0e154013827ac8b157d319f4dbe848a6413888f69ca08306e8e753"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22d012cc8ad34dd603d9a65b2e4b06820bcd241368ab1c58f3e7d1523221a22f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "678784041262bf50259e1e115702226f43fc9e848706cdf77ca80492e8100e34"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dedc67ad89a74da8142eb1a17c8011fbb1d409aab891e253ec1551b1834fd23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6d69c7053d9aa12044829fca11747afaee2bcbee83344357851f715504bd82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2384d234e01ecef101eefa3485dcf88f5b33d1796a8638e5d3fcc38afcca6f1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output("#{bin}/lychee #{testpath}/test.md")
    assert_match "🔍 1 Total", output
    assert_match "✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end
