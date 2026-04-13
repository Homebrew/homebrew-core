class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.18.0.tar.gz"
  sha256 "b8a75709827c009048df112de626602b2cbe89bf89fa9c7ab5ae989e9cfa6cd7"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac8d1644b9e1c3e49f38fc2fe4e6459a1281269765924af1c4026b6365741e47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ca97bde53570606ef3150b8aaf03d4dc45418ebb8f78fb29fa9e0230f23f85e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce2d228dbcb15c152529d2d26e8d5ed645bfa890c9ecb8b3bc7264ee104da284"
    sha256 cellar: :any_skip_relocation, sonoma:        "70e17b1c84c555b0f07eff67275b367ce2dd04461d68dcc356bfab21111dcf90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84cb15db741cbadece4dc7ca02ca77afc6940d121e6d9b006ecbd256b86e1865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba96ef7e829b4e6ef6a9b8b274fd4a5afa383d8175c16f06b6b871383445dcff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", shell_parameter_format: :cobra)
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
