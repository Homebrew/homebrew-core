class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.11.2.tar.gz"
  sha256 "eab85bfa0b9b04d82f084d00260baa073ee145ae582cd2974a85785b6a1661e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d1c4511d032c2547226dd4319929f2696e0877d817a8d88add27afc30b59f5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8804d55cd725b5b3ef6e2633a9a925b626419c7b6784b8462fa04c3b7c10ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741cd65b18e1e2aa6edd0b3b1dcb2bd478d463b87ba3abad45494f570b4840e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "21632db71b0a6ea99ea9c7ff98ce9012b32d3a3023132eee9155df065385c919"
    sha256 cellar: :any_skip_relocation, ventura:        "0b9d2781fbc66c49f9419e77c8070c5227b5ab5da3b278d09081eb0b10122013"
    sha256 cellar: :any_skip_relocation, monterey:       "5d5072ecb6e9a5321f0dc9f3176107d09be40968bb4fbdba4dfdb4ad3b5a8d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cbf559060a88890ee5250840ff151359269b886a9148499db5bfafdbf656b21"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
      -X github.com/aziontech/azion-cli/pkg/metric.SegmentKey=Irg63QfdvWpoANAVeCBEwfxXBKvoSSzt
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev --yes 2>&1", 1)
  end
end
