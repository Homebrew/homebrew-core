class Lima < Formula
  desc "Linux virtual machines"
  homepage "https://github.com/lima-vm/lima"
  url "https://github.com/lima-vm/lima/archive/v0.13.0.tar.gz"
  sha256 "2df48d219bd8f67a3d7cfe43770f768aeb20a1b2242aaba18c58d441d5bd0d0e"
  license "Apache-2.0"
  head "https://github.com/lima-vm/lima.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c86a1c2cdd2579ac03511ee166b9f069abfb2e0f0b81358088ff2f83ca591a00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fe8be341ea6deeda9b89d17d4213672e711320e3f403c70e2562ad941cc39dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ce3c0a07ad2704dede55d435002cc99ef749b8f194634a31fc107271eddc126"
    sha256 cellar: :any_skip_relocation, ventura:        "956871016ecdc212c04af137ae04b93071ca0ae65fa6871fa046ad43c1cc9dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "3efb500a8401769824adbf056a2a94076c26a06c76fa7c86c6394ef14cc1a18b"
    sha256 cellar: :any_skip_relocation, big_sur:        "74c7598708b43d9a389efbb1731a39d6bdee4597c069abad532371eb84e8d8ed"
    sha256 cellar: :any_skip_relocation, catalina:       "6026a0464da0973cdc4b90b4a3966b22f2ae4a6af83a188cadf62c4806f8b6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e709a5806ac3d33793a2e2cf2528dc9d051611affe164f7791a0b76b78fc0e6"
  end

  depends_on "go" => :build
  depends_on "qemu"

  def install
    system "make", "VERSION=#{version}", "clean", "binaries"

    bin.install Dir["_output/bin/*"]
    share.install Dir["_output/share/*"]

    # Install shell completions
    generate_completions_from_executable(bin/"limactl", "completion", base_name: "limactl")
  end

  test do
    assert_match "Pruning", shell_output("#{bin}/limactl prune 2>&1")
  end
end
