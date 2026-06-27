class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.14.tar.gz"
  sha256 "ab03825412ab806f85b26a4726828d93bd22d3dd00bad1c9bd2653bc1d4ca616"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5170e282f8975995e9d19b60973c37fe2ebcdbf70f3df826d622fadbc64bcef4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5170e282f8975995e9d19b60973c37fe2ebcdbf70f3df826d622fadbc64bcef4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5170e282f8975995e9d19b60973c37fe2ebcdbf70f3df826d622fadbc64bcef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "40530723d37ea2f2aeb5cf4e7e41db22f30e416c6646546ebf3ab7e72183df7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10818bee88f66e954af8d2227caa413596f71144bda5293880d33ea2cf56ef59"
    sha256 cellar: :any,                 x86_64_linux:  "47ef123c642aed4624e67ea53a55397628330bfec5b4674382ec58305d013e65"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
