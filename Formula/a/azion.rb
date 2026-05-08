class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.21.0.tar.gz"
  sha256 "54defc2576894a21f89d94e423ee81092d2238123f32075c80c7ca3919f2c6d9"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a429b5cf5535030dda2b3ba0511f6083fe2ccf52813cd84c9962f8acc03aeb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a429b5cf5535030dda2b3ba0511f6083fe2ccf52813cd84c9962f8acc03aeb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a429b5cf5535030dda2b3ba0511f6083fe2ccf52813cd84c9962f8acc03aeb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3df87e8a80bddb61ce999eb26c59d6d053a079289a971daafbf127ee6c414aa1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04479331e21150d2cd1007f05c021be48296fda9696b1bd15a214ab7b1c54e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7b749a145864b9821edbff078161db7ee17de3ca484d81fb9664ef25a3d136"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
