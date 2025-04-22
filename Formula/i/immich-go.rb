class ImmichGo < Formula
  desc "Alternative to the official immich-CLI command written in Go"
  homepage "https://github.com/simulot/immich-go"
  url "https://github.com/simulot/immich-go/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "84c185ee719b5dc173e914c5f4bc5549f4787dc92470bf5fe16225f1eb9ef5d0"
  license "AGPL-3.0-only"
  head "https://github.com/simulot/immich-go.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56e1280a21a3ff37561f80a5ef60250208e74f552297081b97f6e6013618e5ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "086c3d894038e39bc212013c2999b48f61a7b7886c80d5b24d1eee18906d1962"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "df324b031666312788a334089ca5cae230de7107800df47ce938bb31bcd34f69"
    sha256 cellar: :any_skip_relocation, sonoma:        "5155216da4c5ddfe31cc0c59374b8278c0f661e4125f2b2537c21cde42cb85fd"
    sha256 cellar: :any_skip_relocation, ventura:       "a960aaf033e97feb13615314ff64726b06bf093bac9d84abd81f91cf0e00e22c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6b31d73a8baacc56505d8a5f39bb1777e60ba5628bdb2011ad39d97cf95f90a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/simulot/immich-go/app.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"immich-go", "completion")
  end

  test do
    output = shell_output("#{bin}/immich-go --server http://localhost --api-key test upload from-folder . 2>&1", 1)
    assert_match "Error: unexpected response to the immich's ping API at this address", output

    assert_match version.to_s, shell_output("#{bin}/immich-go --version")
  end
end
