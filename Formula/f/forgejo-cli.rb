class ForgejoCli < Formula
  desc "CLI tool for interacting with Forgejo"
  homepage "https://codeberg.org/forgejo-contrib/forgejo-cli"
  url "https://codeberg.org/forgejo-contrib/forgejo-cli/archive/v0.6.0.tar.gz"
  sha256 "8b91194cb1886f253261a4567ee6f83aa34b05a9637644793f88b40b7110322a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://codeberg.org/forgejo-contrib/forgejo-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a84eb3c5d729c3b05135dc82be9be146419e0eee4ccca4d321f32f7d5d276ef9"
    sha256 cellar: :any, arm64_sequoia: "f1037fad0a40d0b6b7202e0ea69955cbc592edcfa85a81bd961ccd6ab311a4eb"
    sha256 cellar: :any, arm64_sonoma:  "7859e5b74231f24a974c76d073a08454b5c43231b5e93bf039c1e3f772732a49"
    sha256 cellar: :any, sonoma:        "759fc9b5ed677fe82a0c0ca2ad71a0c12403adb4da139918306cd554c38d3e8f"
    sha256 cellar: :any, arm64_linux:   "39307b9cffd67788556f7c31c2e704e29e8e0deff61f4c7c394874cdfdcbba1d"
    sha256 cellar: :any, x86_64_linux:  "3d03a6071ce54f9f5ac7385fb75dda911f550abe567e679e27f1c2e61ceb3bbe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fj", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fj version")

    assert_match "Beyond coding. We forge.", shell_output("#{bin}/fj repo view codeberg.org/forgejo/forgejo")
  end
end
