class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.12.1.tar.gz"
  sha256 "5006c72d446e2b634e41d6d760661773ad449fed93154a8c8d461ad91461f997"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87d68076a3612e3ebcd5b3c295901865cbbedd064346db7593d66080bdbc1107"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac00d7a67e70447c2be392ae0dc326435c7be3a08c6cbf3e6679b7b4bf199ceb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1739e63a285a276ef91c2684830fc7f8388d58840e36be153e89a280350e419e"
    sha256 cellar: :any_skip_relocation, sonoma:        "47284149544e97c6a37662b2c2df4f6d19f4eb2ae2f59191131c04053ccbe715"
    sha256 cellar: :any_skip_relocation, ventura:       "f8b97a5b6f6bbab8eea681a615fe85ec06ab02d7768b192e8aa612a9354d26a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc14877d9d6a44581099f667de7b7cdac1597ec69f2d46617661244f6b2a9afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9bb4f3e0ee6a326bf2e89248f35081ca29ab4e01f2e8bcb5b824c8b4714f3d"
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
