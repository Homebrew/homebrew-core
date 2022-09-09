class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/v1.0.1.tar.gz"
  sha256 "be619fe870249e74f52076d16020808b6020fedf2b98685f7c14145a291a2fe7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3df7b381a95693b58a2b1171f568611b6915de8395f6baf17d504c7e0e0db16d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd8252b271500337fed969910f0d9eb9c97c2624d56f32c6854efabc2ec63f8a"
    sha256 cellar: :any_skip_relocation, monterey:       "2438631e820983b4cd80de5cec8472266ac4d3e38a8187f5c6985ab3b1535fd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a93da9a29aa65f744971973bbe0f5df75d94c4a3acf0a7f942ecf68349c279f"
    sha256 cellar: :any_skip_relocation, catalina:       "facb1496c4be3723fba590b9ebb1de0206db27b32ed4a314a84c766a81e7864a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262aeb25d4524fe0e7823b849ef7aebb3a1af8d055a2ade33f27f387c6817887"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    out = shell_output("#{bin}/berglas list homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
