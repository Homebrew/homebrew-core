class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.24.0.tar.gz"
  sha256 "b0b1c0c34b2285585e0e44abc2ac5e718623c3cd3fd41a4ddf25bf7e20bc8b57"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e124288da18063952725e68238558d4cf9657498a910cbe1e3a45698cc06d2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3e124288da18063952725e68238558d4cf9657498a910cbe1e3a45698cc06d2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3e124288da18063952725e68238558d4cf9657498a910cbe1e3a45698cc06d2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b73a924c5161a0da8bf8d37f657cc923567918969577a0cb63039fcfc37cd548"
    sha256 cellar: :any,                 x86_64_linux:      "c747e417ce6d4406d0186d37e945fe2eb882c5bd46b66e1daee0fd7ba0825ae3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com/v4
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/constants.ApiV4URL=https://api.azion.com/v4
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
