class Deck < Formula
  desc "Creates slide deck using Markdown and Google Slides"
  homepage "https://github.com/k1LoW/deck"
  url "https://github.com/k1LoW/deck/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "5cfecf75c0a379add9b3d346cc4331f26ca1cb9f8176e8468db089506cac27f1"
  license "MIT"
  head "https://github.com/k1LoW/deck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "529b027151a24b9069d3558ed42dcdf997692b35336b09d0c9ca486639822d22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "529b027151a24b9069d3558ed42dcdf997692b35336b09d0c9ca486639822d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "529b027151a24b9069d3558ed42dcdf997692b35336b09d0c9ca486639822d22"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0d8c6095b2f953104253b5aea59cca568a04c68db9d6d993b3dcb2eaa7738c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61dd928ae3d50c240b3dce2b40ab37e81f4bb2ff5e23eed5549f091115d74a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "874f7ec7e3d4c80abe02c4ae55ffec15fcc0d0e22bbbed70e6269cb8eaa93c20"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/deck"

    generate_completions_from_executable(bin/"deck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deck --version")
    assert_match "presentation ID is required", shell_output("#{bin}/deck export 2>&1", 1)
  end
end
