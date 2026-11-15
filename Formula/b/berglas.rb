class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.18.tar.gz"
  sha256 "7066f3cdd8b23fa16cdc5945a97711785eb906c5fbdc70dcace5b79a48a69c82"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a6306bd1581c3bfaf49601375169bfede33e73d83ca90073d6396940f0be111"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6a6306bd1581c3bfaf49601375169bfede33e73d83ca90073d6396940f0be111"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a6306bd1581c3bfaf49601375169bfede33e73d83ca90073d6396940f0be111"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "62afdab7acd5d97b5ae4f32e6e0c373a438a17cbef54a20534e7c383ddf0e129"
    sha256 cellar: :any,                 x86_64_linux:      "7fa2e3d514920d3a5a8b48e70ab5ee8e1528c7c305c997433698387fefc57eaf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
