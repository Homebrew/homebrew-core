class Ddate < Formula
  desc "Converts boring normal dates to fun Discordian Date"
  homepage "https://github.com/bo0ts/ddate"
  url "https://github.com/bo0ts/ddate/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "d53c3f0af845045f39d6d633d295fd4efbe2a792fd0d04d25d44725d11c678ad"
  license :public_domain

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "faa847a8ef33784d6e5337a6357a890437b7965ce6e8353940535165af5e050e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "12ef0c2a08ae6e73c6cf73a94e662c513cd9d8cb46ed1567653236d5ca5e7b4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "124fa6334391f5ba314292ba2e47b535cebe68a79272ee5a9d3ad9d457ef4558"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe29278ae4f80f7c8db1de60b5aebf6d80b309b8b3d7cf866f1d092f7a4c518f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "967dbd56914c5b0d578b93c936f311f2af91dade23abefb8d3e6d6d8814b142c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f45b9a3b64d14ae95d1aabb359535c7394fbb9781618992e0d8987009d1b306b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9daa4cc00d03cc5d16024c68429face569f89d68be9206173980833855e44857"
    sha256 cellar: :any_skip_relocation, ventura:        "dc6a83d4395ba0e0cc54890798b9dec02958912ad7f17fbadf2ca46c8236e9c8"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c316d4c6b48ac80d5673f55bec768501c725d500ba9b926fdd347adf55cd79"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e7f00a11029e70caa333a3c33367e564631fcea1d08b36f02437af7b03f810c"
    sha256 cellar: :any_skip_relocation, catalina:       "2b9be177e37cb4650bae50a9527315e700592bdd8a5546cfb7b40cf201bb680c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "85848eab10e14e64a60ffd85a3c5bbd2e72fc3d554ad28fcff82db7f9a44a686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75baa9706ec0453896edf597bc5a9c52c012ea9188555654f698794f578d9f62"
  end

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install "ddate"
    man1.install "ddate.1"
  end

  test do
    output = shell_output("#{bin}/ddate 20 6 2014").strip
    assert_equal "Sweetmorn, Confusion 25, 3180 YOLD", output
  end
end
