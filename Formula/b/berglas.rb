class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.12.tar.gz"
  sha256 "4a26855a5862c8a28626b1758811ed5acf3b8e18368f3fc37e43334a25694f6f"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b687174e7ca89bb266f3c97d174d43dc9a503b937bb64b21f938dd3531034ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b687174e7ca89bb266f3c97d174d43dc9a503b937bb64b21f938dd3531034ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b687174e7ca89bb266f3c97d174d43dc9a503b937bb64b21f938dd3531034ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "385bbadb0e515931ec58967f7e64f7008e2d0812912f59d782a8461ef0c70fd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e9652f86156ccc64cbb75e84fbbe9efe3cc3421aa8a0935f28273dbf7cb218e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bda8a6cdd6d72030fb6d2250c02900d622920857eccdbb7b416fc563d0edda93"
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
