class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.22.0.tar.gz"
  sha256 "b0862165dda7be15084e73e2986e87e8a661d177839b6290e2d0281daa1c60f8"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92509a578b799863c5c1a96834b23a9959f711025686b90d9481c6fe54cbec7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a31419f0f8b2b4be3e5e5d537f49690da21daf0d33f94b2059138256b0015f15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84b6eb2a723822a1505ae0d2c46b977fa30503f4015f9c59571c76f659ea9f43"
    sha256 cellar: :any_skip_relocation, sonoma:        "843df24e19308aa89a50160d53983576be09214f3d4f20566ef1f827df8cf91f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50ab5b5daafc2fa1b6c4357d37e4ca6ea29a6e30588166231ac58b919c99bb09"
    sha256 cellar: :any,                 x86_64_linux:  "9ca85663dd1d49924ccdcc4f6438a660d1e6e9afe0948eee5acdf404667336d3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
