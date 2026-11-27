class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.20.tar.gz"
  sha256 "2d4ea8079d642b68f2bbf4ea5f8df768fa680d29e68b449f4269206d87f685b7"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    manifest_sha256 "ab5bf45cceb77d77335410520bcb3ae11d5ee77d6cffb42fee0ca1e30cc3906f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d8ed3fd4a67b45464d4dd6327e778b2cb1d0fd4a8a135319530e85bd640c523f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d8ed3fd4a67b45464d4dd6327e778b2cb1d0fd4a8a135319530e85bd640c523f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8ed3fd4a67b45464d4dd6327e778b2cb1d0fd4a8a135319530e85bd640c523f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ab57f5e65ab0418a1b74fc05270bc7567ecf70baa8adc944f0a4dbcc8cf8c672"
    sha256 cellar: :any,                 x86_64_linux:      "eda56f9d06147328427f682f944efb96ae621daf77084194c633f87c3add9900"
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
