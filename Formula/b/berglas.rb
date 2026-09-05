class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.17.tar.gz"
  sha256 "398be8a793f72670307139ba9250f5082829f6b73870555bba17900a54e93c7a"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ebd8f428d86e1cec1ad5d2813a923a8ff3d403f38879ded45cbcba790139295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ebd8f428d86e1cec1ad5d2813a923a8ff3d403f38879ded45cbcba790139295"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ebd8f428d86e1cec1ad5d2813a923a8ff3d403f38879ded45cbcba790139295"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e306be8ef9b46ca6eb000b6e26b5832d250e441fe36e4f8a4e0be12cfdf61b2c"
    sha256 cellar: :any,                 x86_64_linux:  "4b306c05c322373c23b8b2a80cb7b6b48b3b6ce3c10341203d3143835c73f177"
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
