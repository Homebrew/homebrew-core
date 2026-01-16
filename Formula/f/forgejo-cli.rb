class ForgejoCli < Formula
  desc "CLI tool for interacting with Forgejo"
  homepage "https://codeberg.org/forgejo-contrib/forgejo-cli"
  url "https://codeberg.org/forgejo-contrib/forgejo-cli/archive/v0.4.0.tar.gz"
  sha256 "3dd84c58c8c5d5fc22b8456d9a4f35323e0386547743c6b24295a3dbc6a56fb7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://codeberg.org/forgejo-contrib/forgejo-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45379a91b70c0b9ea6217a81f4c5b4e180b3c38758eed9dcfd08e730aa2f3df2"
    sha256 cellar: :any,                 arm64_sequoia: "6e4acdc5869b8889fd0db031f63dfba57c7de45bd218e60474d3b674dc8c87ab"
    sha256 cellar: :any,                 arm64_sonoma:  "edf8b40748b1c7c5a1a8fd45f88c106314a16c3be9b38a62ac1fea924a841ca0"
    sha256 cellar: :any,                 sonoma:        "26f05774cf28bc8e35005ca1191eaa7e9180b9cbdc1a1324e04f7cf9a4b7ebc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55b14093f304fc7b12b1289c88a6b62e3a8ef5a6ec279b745acc1dada5aa5e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150dee1c8434afe85934ef1c9d06e8e2c4913f288e4c35b2fcc595eec6f70041"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fj", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fj version")

    assert_match "Beyond coding. We forge.", shell_output("#{bin}/fj repo view codeberg.org/forgejo/forgejo")
  end
end
