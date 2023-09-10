class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.19.2.tar.gz"
  sha256 "4a872fdf1654f324c849256cc898ae09dd18bd81281cca310df6606643e8fe56"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1344de08ed796f901096606a02593303b38f2dc2518b20c813714a33176368f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59a96cd3b34f54db91c5a680991ffbda6b4171a82a155354f3de32abd40a27d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72e8297b91b24b82b4e20337ec5f04b63b3e04806b17387886881a2762ebb9de"
    sha256 cellar: :any_skip_relocation, ventura:        "646a4b5603f48d6f2c0bf57bc9542bdf43edc49517f6ea602f9371b8f62d924d"
    sha256 cellar: :any_skip_relocation, monterey:       "edd78696dcb8a4c0d731f8956716136cccc7f24e78bdd22f5e6cf185b2bb9e12"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7d1f3f66b317cb5c847ca73e18bf90b953dd12c188589ff612fc1197b906bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f6947a5d95676bafbb38c18db8db741896de8a963dcd2e144c889a36ac41508"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
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
