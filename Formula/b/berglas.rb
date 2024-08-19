class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "e00382df4ca08e777fb773c83bd67d54e54dc423a493f993a3f023d38f811aab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cedb09bebbe4c8f6933a1b810d8e0d9ed236d050c273a66952a57fd324348318"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3a8aa66bb4c340a5d4fcf3c9a57f3d989c161a131ff93e13e1fd11db7886f37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860f22ab116f25a3a31ce31c6972dc9bf69a67e79fb0bc1fb69f300873cf1ea2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d972024d5e88d62857df6303f1ad06cf9edbd6071c02f334c99fe12107835358"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c0cba269b5c51fd1a43c2f05209eebc0e32a8d4d2b3660c9620724b9282e13"
    sha256 cellar: :any_skip_relocation, monterey:       "e3a61386af637a62a61dff1e1cd0c05c5e7ad543fb7bf40aeadbad38aecf8a98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "161cd8874099448d3ca75b02d426c9cc9aec558fba0318477970bbf9c6d5bb57"
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
