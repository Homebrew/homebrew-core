class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.15.0.tar.gz"
  sha256 "50596b224efd755ab5965eb415f02b1eb1a51279b1c3e118352ffe036db537f8"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68a3fa85f6677bc289298e013d2013290e117a008c767fb913bb472b895e0f65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "700c4848794814c7ee800bba8491dcb2b1f3d14bc5cda5c0d24522fcb5ee1e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1959bac7bf94252ccfb5ec5972cd94cc809a2f6162d311a641c3bec536364e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f03f3aadeac87826010f5d4a0b8472c84ee08fe5a58bdba141cd7b2ebfc072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4da5b3f00409fadd46b13225d3159f005ff5607eecf71fbd4fd120c797077930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c6fdf67a4faef5d14635844d628468b6305b55dce5e3c0f5961b99648f0a46a"
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
