class Juju < Formula
  desc "DevOps management tool"
  homepage "https://canonical.com/juju"
  url "https://github.com/juju/juju/archive/refs/tags/v4.0.14.tar.gz"
  sha256 "dd85e4297726c562fc6c693a0ee82aa9309e300d2be86f0dd16e47f99c9dd43d"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https://github.com/juju/juju.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "110d05a82ea1b36fac170132a4e7dcbebf933d4032693e27696dc71b019c92ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f1ab8c15953a0d1bd5a4f2de17962da0f0cdde6193159aa4dc0947fcd08f800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f41c8ee86f6a92eb4cf64e08f472c5992066153a940ce0c92dac7d9e392e35b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "433aec263eb4e26719f1020fe34dfc81dde8e41deec5c90908d4ec99d9fcf3aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd5c463b1f3709e2f3a0ea55558459ad2f2a17a67b31c1617ee002b2d54e97a6"
    sha256 cellar: :any,                 x86_64_linux:  "88c8ff492e2fbb9af47bf2f0af1639b46968c056f83d9e0cd7db9a83688f1f68"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/juju"
    system "go", "build", *std_go_args(output: bin/"juju-metadata"), "./cmd/plugins/juju-metadata"
    bash_completion.install "etc/bash_completion.d/juju"
  end

  test do
    system bin/"juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}/juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}/juju-metadata list-images 2>&1", 2)
  end
end
