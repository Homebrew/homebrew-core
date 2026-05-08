class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.24.2.tar.gz"
  sha256 "62687c0a84ceec76d17e30e494dcf8e65c7099a2e24a6a521a41854b8eb3759d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a131a1ca4507b36095146419fed6012553f78072f3d89f2bf64a71a98e18f3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12dcf0ba46f69d2a9e4e00e01fd44ea236bdae98d8b0af488ba5800f6686d763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba8a087e9cb66245ad0352246f22d913dedb672e67c666560a83ffe32fddb841"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a231e62cdf80e23839acd6dd7b06370b9d9efd619d4887ab2fe96f400203903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59cc9c32c9435d268141ab600e4c2f95a5c2da1d82cc3ec10ab569ef39064559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa56f319728b6bfbbf611951f49a917f9e73cba4a2feb8dd6fa1d2f11a85dc34"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

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
