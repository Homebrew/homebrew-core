class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://lychee.cli.rs/"
  url "https://github.com/lycheeverse/lychee/archive/refs/tags/lychee-v0.24.1.tar.gz"
  sha256 "51bf8e1ca4da4ea3a326bbfa163ef68920bbc8dc3b84bd094bc86e43fd674e36"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79181a12ed9fd771fb89f3e6cea7e3e728b57b92ebc7d6658ea62bdf0bb82a85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cc4ba39cfb757d80be99310bb5f8aa3cf792ddd1d7ae56f13b2fe9b4960aadd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbb99f1381db7cfaf43e30f3bf9d43d5e5972eba4a9eddc342e4c94d078a3904"
    sha256 cellar: :any_skip_relocation, sonoma:        "31f192341d0f078d01d3d89b216f7ddfd27179c0119e912b04822aae772a646d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62c25f3893b02767c888004eff09aa48684727a3c3907891907438b4335ac801"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd095b7fa8870bd661e719ab559d4cc18198f5abb859f163b7568f09f4822492"
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
