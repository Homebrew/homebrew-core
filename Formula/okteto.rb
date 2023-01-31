class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.12.0.tar.gz"
  sha256 "fddbef4d32a6ffe107c8b1518781446a3d75ae78c289f42ee1860e13e1a4a450"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cecde83ef677f16881b7fc9ee2a94a97276ba3613bf0a0821005b26e328da08b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50b75761a36e274f79dbfe938d75b30c0ae0e6524d8ef1c03c86b555dffed502"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c495e890db01c1cd6398dcc80d25baad246bad4dd25a2736c9f25e6ab3432571"
    sha256 cellar: :any_skip_relocation, ventura:        "107ac25e295958b43ecbfc64b6886e79dacea596fc8ac3a94eea9b32493be75e"
    sha256 cellar: :any_skip_relocation, monterey:       "5c51870b416dd30ec68da3d85d59548246f395cc754a39177c918aead2b1fa09"
    sha256 cellar: :any_skip_relocation, big_sur:        "16e33274ea7ae0f04af863b0126b0e3bb3571d2b7478e86a73481b1cb688a7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fd1bed1c1b51359e705d4b12063fcda9e9577dcf36edbbc4590000ddedc1362"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
