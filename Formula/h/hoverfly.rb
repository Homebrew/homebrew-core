class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.8.tar.gz"
  sha256 "9dcd10b47e56f30beee31ad6d4e877eec0f546a48aa2450b07bb6593baa0e235"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aebc414e68d8dfb46c3177a96aa88e77375495e6d4946a979cacd4421d4b5b6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aebc414e68d8dfb46c3177a96aa88e77375495e6d4946a979cacd4421d4b5b6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aebc414e68d8dfb46c3177a96aa88e77375495e6d4946a979cacd4421d4b5b6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "70cdc7f13e774b7026a010d85be5b21be240414260968774dfef54ba99bd310b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a9e53165c169839206d1fd24bffae1b7e83b6d1e40b1ccc21a0ead2dad4a26"
    sha256 cellar: :any,                 x86_64_linux:  "8d28a96073989ca7720aee828a62e8cb2ed076d1f91e6ccdd8b7e350fb76686b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
