class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "624b950f4dec1a34eeed15b2162352e0a47d78f0609125864710f490de34fcf8"
  license "Apache-2.0"
  head "https://github.com/google/go-containerregistry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d15d4ebf0b40154dc03e24fb074e7ffb0ad1ceacd68db3d63e9cd31015fbfef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d15d4ebf0b40154dc03e24fb074e7ffb0ad1ceacd68db3d63e9cd31015fbfef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d15d4ebf0b40154dc03e24fb074e7ffb0ad1ceacd68db3d63e9cd31015fbfef"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2383011d0bbae459fb1e07575c4cf17d7ca859916991aebba106db7e5a13c08"
    sha256 cellar: :any_skip_relocation, ventura:       "d2383011d0bbae459fb1e07575c4cf17d7ca859916991aebba106db7e5a13c08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da60b05afd8010acad34e54808360c9a0bc1b72ceb402825f426174950c66c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/crane"

    generate_completions_from_executable(bin/"crane", "completion")
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
