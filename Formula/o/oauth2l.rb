class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.3.0.tar.gz"
  sha256 "3f708e3fab87c6ae50e0608b02b01a66ce427a4097f3a73f1fa8c6ea43839110"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc2222b38a273a02d10469b8afc109f2a4a56aa7a00c7d73d0cd7c7e40f8d8ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "536c361c46b2a7cebd434232a569a58bf8b3d3f044d87a0039e9bc15fed649a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a27a3caddf537d71ba7a9141bb45a1014d87ac09860ce4d8a7028f2ea0889b0"
    sha256 cellar: :any_skip_relocation, ventura:        "5780d38cafe48c11c898d2e93136236f125cf395d8a0d1af64c152971d948b88"
    sha256 cellar: :any_skip_relocation, monterey:       "85bd37fe734114478406c309c2942b21b8f214fba580ae255e4a928c39b922a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6340b839cb5e06f979114bafce5a67786bc1dbd6c41e4f1875c32a7de65704d9"
    sha256 cellar: :any_skip_relocation, catalina:       "e7ea7d1924d3c3f43ed24dd3f8827d8632bc7d7b4464c3b42a5d38772eda7068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d23bccc4390cd2cde0becd13dc32a7174b66072c7ebbea4e438feddef466cd80"
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}/oauth2l info abcd1234")
  end
end
