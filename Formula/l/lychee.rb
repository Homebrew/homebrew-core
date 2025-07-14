class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.19.1.tar.gz"
  sha256 "20870738b8a1ccd4658327351682382a177234014ea5e24e9f932f905b2f7d35"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "970aec35716171913158942a0590fb6f75b6d120702b302571394f74faa0a65f"
    sha256 cellar: :any,                 arm64_sonoma:  "762de5cedde9fdc4588acd55208f91860744edc16a8e9172e6d786f54490d847"
    sha256 cellar: :any,                 arm64_ventura: "628057514e1f65c396eddc837b770e4fc8f427f8d0ef68ee6dabd34aeae5ac8f"
    sha256 cellar: :any,                 sonoma:        "8dacdc755b5ad974ed1880356afd6f9501c7cf9c306af6c5db1128fb838426ce"
    sha256 cellar: :any,                 ventura:       "b7c4bc0662db2483f84e840a5f8ec7f9d28529ff51788dbe5486b22ee1d6d0a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f4223d1e8d22087a3cbd29c41e02d5d03de1887384606734ffe6cd676d95925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3759ef3e9b38c1785ef999e25ab22bb84ccefd5b65b27ea3ba37f851bb63e893"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total (in 0s) ✅ 0 OK 🚫 0 Errors 👻 1 Excluded", output
  end
end
