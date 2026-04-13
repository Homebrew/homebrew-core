class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.5.tar.gz"
  sha256 "5252824badab74be58e0603fed69afbe3fe82f07f519a23c1826d5cbc82c7116"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1314a2775a4eb26e5d2a0c027058f15a0a383b308dd79d284dabede1a5798b85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "878f450be49bd170b357cb73dc92bbeab41bf146da70a31cf7891d9778340bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a37ebbbf04d22ef1bd83f4914ceba3e98da5d90eafc1510298f8c307d0f3c4b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "24b7dd3a31424b3175773edbff243e25469e53fc84688e5a16d8cb0bf1c094f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0f470e384b9dd41f53e573aa4b47d2dd6c31777fb1c3172342e0f7601c46732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d4ab56fdad4be68baf434508b8ed657a97f890e91ba7605819d9473505145e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata", ldflags: "-s -w"), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system bin/"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
