class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.16.3.tar.gz"
  sha256 "c2f3f6b50496cbadb7d9caeb6cfc4e0dab8f99aaed5d9a560b30208cb68108f0"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18490f889c68e66727a7160c98ff5d09349d928f0c80162289c007a6faa9ec89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48d93e4ecc7c8c5060ceefbfef420edd79af1faffa54bb9d31f53028da6c4aae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b59d57aedbf6cb1e8cc9f68bb98860dff1773629d6900f4c5ff240595a29f03b"
    sha256 cellar: :any_skip_relocation, sonoma:        "93906bfff2b641d832991af3b12eb6e15983de3d8c9e1ce84ac3064339892fa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "edf3f494751a5b80b73c00fef69d9d54d105ce877b178a3ec7d25e1c82ac6e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb17c2950357dfb68b64c9bdc7e52aad9a7893bd36ffa3e790b9e80da88b6aa1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
