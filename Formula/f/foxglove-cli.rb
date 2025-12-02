class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.28.tar.gz"
  sha256 "e531c949adace7cd9c97b485b2ee1123af34ef2049d2bd956be161faac1862e3"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffb7a9d66e0222484ed0426f28c1968ef06e877761629166713477a4ef57ebf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8233701fa832a76c996b0514f8ce3580a34fca53ac62828f0d47554c903d2435"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdad6852e83dbf660370368889393bda6cccb0d2a3c995a5d3e3d5ba17058c38"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1b9f944d31c1cd497f7fff27b1bca19f7faf118eeb7321318d9156aa50e6f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d1345ac0242e6bb258bb8cc3d1b8c128fbd11c01b8778990a890154227bdbf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d3539f0c25bf6ae326fe5732d9f93579a933fcfc1917af2f1f611170ca4b4cd"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
