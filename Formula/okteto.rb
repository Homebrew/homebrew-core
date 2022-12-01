class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.10.1.tar.gz"
  sha256 "f430bf60984fba29e3da40fde857ec197ead5f1ce68d27df2609e4b7ef767e62"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6257539f6389f17f09a3b0e1f272064584250160285f725efad5bbb61995f638"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54a1c0e8da6eec92e696d6e9ecb26f04ca8ac60145970465363b3cd41fe10732"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4df8e47d7d7626240a311cdf0f384cccf321bf484179a6002a2eddd445a65064"
    sha256 cellar: :any_skip_relocation, ventura:        "ee331f0f87312636fb2e580250a9900d05dc61230c05c8b48ca1071e0bb23fee"
    sha256 cellar: :any_skip_relocation, monterey:       "277fb834152fec7b227195ed29d9e7d0a3d2e0b423699d9501b5705e889952a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "977cf758374c255bb156144c72106a91b2fb95eb0082aa49f65abd627d1268ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9983456af079c87f7938cd34d339f8301a4272be91bf740da9c6ce78fcc28fcc"
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
