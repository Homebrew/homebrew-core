class C14Cli < Formula
  desc "Manage your Online C14 archives from the command-line"
  homepage "https://github.com/scaleway/c14-cli"
  url "https://github.com/scaleway/c14-cli/archive/v0.5.0.tar.gz"
  sha256 "b93960ee3ba516a91df9f81cf9b258858f8b5da6238d44a339966a5636643cb2"
  license "MIT"
  head "https://github.com/scaleway/c14-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "137f585fd6aef342e9ac97ce6ffe819d30641727e7f9d621fa6d0124afeb46f5" => :catalina
    sha256 "245dc470e7883100e9b8d3dd229a5fbf2e0960993c7432be11e31ba7ef887f71" => :mojave
    sha256 "6b3262c0d209f01dd93a491c541ee7f9fedca9f6ff03203487394e0e4f5cdecf" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"c14",
           "-ldflags", "-X github.com/online-net/c14-cli/pkg/version.GITCOMMIT=homebrew",
           "./cmd/c14/"
  end

  test do
    output = shell_output(bin/"c14 help")
    assert_match "Interact with C14 from the command line.", output
  end
end
