class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.277.tar.gz"
  sha256 "ffb4b548505f5c1c764a7a0a62118fdd801fea9715c55b357292851c48de4320"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d72ffb8183578ef1c6d08b654f0255205617c8abeedf50c62267c3c7f565e276"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a618409cc1b70a88875e3efbd5b35f5315396d85989c4173072388a0c6e9f4e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f13994451ca4c1ee354d824138e4649b067c239c784b68941e52d5938faa79cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "834b2d6aa63d64bc39f63910672a819eadc8019943224c7f597b4dc7ca86260b"
    sha256 cellar: :any_skip_relocation, ventura:        "e0220e02775f14449ea12f48fbd21493af7c05a2e6eba8ea5e3af4a8c36be68b"
    sha256 cellar: :any_skip_relocation, monterey:       "bc427c3245a5a6a060e4a483b2f69ba5658948dfed74960f1fd174ebe1612222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "126592c048b670a054fa6ce5d3d36718ba3a258161b58e4d1ca4db693b1f9a52"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
