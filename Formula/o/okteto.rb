class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.6.0.tar.gz"
  sha256 "f8b92f0ae879886df75dbfefb4f7e60741cb048322e66166a60aac662239eb26"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5495feac6e0cee5456bfdd97e031d2e4dd91a1a5dad8e5a1c2c7244570a1f8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00fcfbe6f5424d5a1b2edbb7c436551abd0f98ea5845622908a9365ff5578d5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af1a57c0daa690f94e11dbbb016897bdd2e198207010f69f7931575483494c60"
    sha256 cellar: :any_skip_relocation, sonoma:        "42aef5a76be48374a5b1e41de14ad342c3813750a090b9233bc20d9bdb4d1108"
    sha256 cellar: :any_skip_relocation, ventura:       "51ecc4c948c395c34008ce1565adef8ccb08de747b05e3033bae322a3fc4a3f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceec829c40c390515907e68700df629b677429e7ffed3ae50d147402908e5286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28c10e34c3c7d22b7938315af8bff0c715676bbdc09bd91b2b9196e3dabb942"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
