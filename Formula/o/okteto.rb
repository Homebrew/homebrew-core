class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.11.0.tar.gz"
  sha256 "b521818d64cff3c013b07a227b66f9c0f456e0a7537e4a7fd7aae8d45ceb991b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5f0b91e607c0620adb28f0471cb23bc65eb1deff08c3bfdff8ca60f867a4d0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77bcd7d4382accc6a6b2ef2346f719a25d2936f08d5205cfc2d0245514b03cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa69ce6c69decc0b64b34ce77ef2b9cb565b6f7f295393c98ecae8b98772a68e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a08b982242a4ec7aef1c2af75913643d6b6c04a3a281962e3d7814675a773d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7d1fa0cffcc16bbb16b80af844586d39d40f4fa9f5a01dea8b140610618d9b"
    sha256 cellar: :any_skip_relocation, ventura:       "7a1bad1aba45b45426cdeee0577a46c16f90159f2aeac48cc2c5a6620a532dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3089cd150dfebf8c1815fc405c62fbc0e1c468975ada1d6dd6cd2d3fe799d072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88952d80955518667709cda62277888dc9250f3e9529cfee273c416aaa5fce1d"
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
