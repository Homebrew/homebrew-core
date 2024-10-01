class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://github.com/coder/coder/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "843d7ee309ffa142617973dc1e8d92e516c97c066bbf55b214bb809006ceb572"
  license "AGPL-3.0-only"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c3d2c059c625b5d3eadde23cacce54682f679e8e4e3b7b088222141ac332a01d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a88210d807a3a8b2ec0bde8fccbd31cec0a113a00c1b920de763049f32b4418"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42eca835638f3c25492066a8e00b878cf586a679545d9801a3fe089afd838234"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4783bb8d3b058e11e690ed1fd0e0aa475f4362e448bcff6f187d27090bd44d5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3554103210badd7e6faab42e370f38f46301dc94ce581930244ddff9d46d4b8"
    sha256 cellar: :any_skip_relocation, ventura:        "e037c844994b985464488d1a657d70aaf0f74a0d603cb3f95bb725dff682503b"
    sha256 cellar: :any_skip_relocation, monterey:       "4821d6b000b7a4e0af579277e43fdef2552edbc9e434d9862dbf99d53aba7899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d0309a8bd3876454b4565ac36264ec05562d67aa204a0f2f55fafac31827059"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "slim", "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end
