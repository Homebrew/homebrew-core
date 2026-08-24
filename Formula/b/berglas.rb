class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.16.tar.gz"
  sha256 "fa4936771f24414e3e8d87ba0c134426d2f6d9b17110a29d9cf9a5e21b7aa0e6"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f9df172b5f73874ffc1e683f3d08de7dfb4b9eb75f9a1b866b64e5575ffc067"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f9df172b5f73874ffc1e683f3d08de7dfb4b9eb75f9a1b866b64e5575ffc067"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f9df172b5f73874ffc1e683f3d08de7dfb4b9eb75f9a1b866b64e5575ffc067"
    sha256 cellar: :any_skip_relocation, sonoma:        "0882dd1958c5c5f816d51a01834cd20bc96d0a2cc03103e87c974c41691fcd7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0172dcb9c2736df4402dfec2e695c595dc451024f8a9c25fbff3a9a5d03d47c"
    sha256 cellar: :any,                 x86_64_linux:  "5aa54cdfd1121c07075d8eefc13755b6d4cdc0e36de02d1885f7d437b9460228"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.name=berglas
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
