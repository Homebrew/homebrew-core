class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.15.tar.gz"
  sha256 "b0dd26cfd8e72fbcc0b7b9e5b7113aa79dade0ab14da0783b30d9407642910d7"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5521a85cf64d9de7623db7673b5aea5db9154fa0780dfa0d5b337ad602221353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5521a85cf64d9de7623db7673b5aea5db9154fa0780dfa0d5b337ad602221353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5521a85cf64d9de7623db7673b5aea5db9154fa0780dfa0d5b337ad602221353"
    sha256 cellar: :any_skip_relocation, sonoma:        "486be99420ff1b3d8364450871d7c45a0916724e3387370a6da683a7f5a65bc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f934dd9857d8eb1c6e7ad0b8d5a70d376cc4ef282366c370d01aeefd6f4de775"
    sha256 cellar: :any,                 x86_64_linux:  "bbc5f463ec6fbe18621e73278a5df200fce7a37f3eec2394695dee67f75db138"
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
