class Melt < Formula
  desc "Backup and restore Ed25519 SSH keys with seed words"
  homepage "https://github.com/charmbracelet/melt"
  url "https://github.com/charmbracelet/melt/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e6e7d1f3eba506ac7e310bbc497687e7e4e457fa685843dcf1ba00349614bfdc"
  license "MIT"
  head "https://github.com/charmbracelet/melt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9867029e68c10f409404183ef028dbf0b392117f38fa4dcc8dfe7cbf944a2c6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "547013e6780070ab0e514c03cad053fcff034ed2bd938b43bb5ece9b71424274"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "547013e6780070ab0e514c03cad053fcff034ed2bd938b43bb5ece9b71424274"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "547013e6780070ab0e514c03cad053fcff034ed2bd938b43bb5ece9b71424274"
    sha256 cellar: :any_skip_relocation, sonoma:        "01a243d60bb828e77591ce38242f3e63097adff342a71b87eb8864a17234141b"
    sha256 cellar: :any_skip_relocation, ventura:       "01a243d60bb828e77591ce38242f3e63097adff342a71b87eb8864a17234141b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffc976877557e3d59a0c68687554f754675e683848fec8bdbc7466a257327e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea2cb7ae00d2065de9d82efa15f5bbdba7f01a2424f83238a9635ecf4a4cc25"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/melt"

    generate_completions_from_executable(bin/"melt", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    output = shell_output("#{bin}/melt restore --seed \"seed\" ./restored_id25519 2>&1", 1)
    assert_match "Error: failed to get seed from mnemonic: Invalid mnenomic", output
  end
end
