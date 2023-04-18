class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.14.2.tar.gz"
  sha256 "b6440333aa9ee25e64dc6525a6018ccff8e53b6b7c815595eca1a509978c4647"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7db00e9729801e286f7b89052e439e9baa1ee61db1ca9067002200b5500e2a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "027cef9dac4007023f3d8690b154bf690094e64f08c2f73c6355f62e0caadcce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "521550429334ec0ca38c7aa44c48693ffc882cda98d97d78dc1113c696d5959b"
    sha256 cellar: :any_skip_relocation, ventura:        "593a7795a9c55a5972f57fff5cc40d13405d628620975adfab4aed8012b7342b"
    sha256 cellar: :any_skip_relocation, monterey:       "9ca264d2b7e7ac4414e27fc5e3de0fc5900dd259c421d2db4dbabc6d45e8d19e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f80317e0198bd1f7c0b62ffefc03247f959cf2f6dc414132c433b0c0da0ba795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93f74a12dfeee76b6a6a076b26fa542482a17a768a9f3cf80372a0ffe48dd0fb"
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
