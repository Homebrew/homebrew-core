class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.16.0.tar.gz"
  sha256 "f7823495f8b8634f10564aac0c02ea95a547631e1754e2b07d0ef93e66057b30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ef83f5d4a95d28e32948147e0c7519655fed6a2090ad38eda670359a66b1680"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "026865d77b7c2411c9feae3a92135f1045b351d60a9c714f95202cf407b803f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a17bca1bcee7823c20a1828004d76c46c35095acf8d88ed4a3f9aa1014f513e"
    sha256 cellar: :any_skip_relocation, sonoma:         "31ab10be1b0aaf44e3fd524b99efe7e26e6132a796ed24e49404042f85dc0f07"
    sha256 cellar: :any_skip_relocation, ventura:        "9c0d7cbe30ba72f7ffcdb7ca4a6d8425e9f428bc1affce8f9b51b5e416515fde"
    sha256 cellar: :any_skip_relocation, monterey:       "17685bf111e371cbce46af8b6b813114581cf46909fe4483aa8670902912f7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "949ae521ae10353e9a90760f4075f0e9718e91cb9e936ea86b990d2dad335516"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev --yes 2>&1", 1)
  end
end
