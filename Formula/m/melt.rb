class Melt < Formula
  desc "Backup and restore Ed25519 SSH keys with seed words"
  homepage "https://github.com/charmbracelet/melt"
  url "https://github.com/charmbracelet/melt/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e6e7d1f3eba506ac7e310bbc497687e7e4e457fa685843dcf1ba00349614bfdc"
  license "MIT"
  head "https://github.com/charmbracelet/melt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6064c885c390d6c1b80356c097549fc1eea43ab0a1d12d50e2fb6cc3c1369321"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6064c885c390d6c1b80356c097549fc1eea43ab0a1d12d50e2fb6cc3c1369321"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6064c885c390d6c1b80356c097549fc1eea43ab0a1d12d50e2fb6cc3c1369321"
    sha256 cellar: :any_skip_relocation, sonoma:        "859066b5a763b3515215482fdb28cabdca370c42ace805013046f56d6233c583"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "473a37ff07856f5f587fc22a267edb9e268aaa100cc60980bcbe1317d85454aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f036b14fd312ab891ca6ba924692520ccf73c4430e0c0d4dd95128858b11923"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/melt"

    generate_completions_from_executable(bin/"melt", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/melt restore --seed \"seed\" ./restored_id25519 2>&1", 1)
    assert_match "Error: failed to get seed from mnemonic: Invalid mnenomic", output
  end
end
