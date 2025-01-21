class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.3.1.tar.gz"
  sha256 "946357d2f199e4cbdbe4a1a30eefb42523c7af3fd75fde3b980c857cdd3c4d78"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c468818c4c83bc9e37caf0c364f165265f8d0971d21dccf74b501c97694b3c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5103fe00413a7369a51ae165ea74b9a7e1d94bf45ac4d5e3572bcc46c0c87641"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56c430357965160a9df457bdfa80a9405c1a952efb7c3a6ffd276b783d9c86ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "466b2aea1c81beea4fbe83b5b07394b4506157d4b14c38d024b94d7340cca2d8"
    sha256 cellar: :any_skip_relocation, ventura:       "a2116de026bea78941c4987b217b78eea6af67cb45feaafbeff8d8df4a887377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d23ae526b73a84821fe3b766ebf59d53b92551fc26abe6806b550f87337223c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
