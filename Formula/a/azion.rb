class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/3.2.0.tar.gz"
  sha256 "7006b132e6529d50e2ba4ab9c2d1d9aaa9850601ef4fd9ab11dc211b596305a9"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aae189ea946c367e4dc6907cb3ab8b4f2ec05ac7f5b9de455d3b3deb9a3d7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aae189ea946c367e4dc6907cb3ab8b4f2ec05ac7f5b9de455d3b3deb9a3d7c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4aae189ea946c367e4dc6907cb3ab8b4f2ec05ac7f5b9de455d3b3deb9a3d7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a78213ef095f3eb91464d8f926ceb0746e05906bab512b62d05a026d8c50bab1"
    sha256 cellar: :any_skip_relocation, ventura:       "a78213ef095f3eb91464d8f926ceb0746e05906bab512b62d05a026d8c50bab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2595d1e81ffb14f1e9ac2a0666ce78b3ac0776703bd959e638f7086e4919fcc"
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
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
