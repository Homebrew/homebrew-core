class Ducker < Formula
  desc "Slightly quackers Docker TUI based on k9s"
  homepage "https://github.com/robertpsoane/ducker"
  url "https://github.com/robertpsoane/ducker/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e9e92a6d5684d327dbc07d005a20da101dc044d52cc094cf8ab4883eb87a768f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5f016a60865df4c08968328d36e6a315e83af5f224d6ac519a4eaaec72258c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a4d66014d8b66e55291daa4dc0bd701f630789529bc7271906c1ccf23aa7532"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd32634a7c73b66eba7346773b47f5a05c891448da60fa574c9ed79c30255947"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe2d895e4ff41671bfc0e0cbbee3371f5b39bac0510b89f622d05786c8932e27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20b8c248fe8a165a64d9bb2be4e59162697375869b4b68173622338db1ddbbfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "437df3ec38b3fec9eaccf73167b215ddb3ddfaef8402a9b9254472aa8e57e44c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ducker", "--export-default-config"
    assert_match "prompt", (testpath/".config/ducker/config.yaml").read

    assert_match "ducker #{version}", shell_output("#{bin}/ducker --version")
  end
end
