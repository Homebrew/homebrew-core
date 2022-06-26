class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.10.4.tar.gz"
  sha256 "779752e853d5f59d73e37a74681d52ba6f98ecb54c31fe266d4b85bedafc7774"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a173734e62e0e060e03ccd0049289f0dbaa687d376cde9926a4834d9a7dde5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0330737821e56d883585187c5db80abd81faf4d014869d2e2cad3eb0e34bf17e"
    sha256 cellar: :any_skip_relocation, monterey:       "5602a349c56579915cf29c3995f3a214345c4b354bc8875eb8c639040745a535"
    sha256 cellar: :any_skip_relocation, big_sur:        "4393fd98611c97ba9bacf53166ce0e42e729d8ea89b697f3e81abccf5bc006f8"
    sha256 cellar: :any_skip_relocation, catalina:       "2b694152a729cdb850ba5eac3750247999344a078beddfdad02bf024fb8637c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea955ccf87bfcc188d8132d2ef86b0e520843b61a5c4d9d54ae9522721cd2c55"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"
  end

  test do
    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1", 1),
      "The credentials are not initialized"

    assert_match version.to_s, shell_output("#{bin}/gmailctl version")
  end
end
