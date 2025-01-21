class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/2.5.1.tar.gz"
  sha256 "c4540dd917e5e03ea9f78d69e9093bf59b8928f3efbf041ed0748501dcdaa3b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa412a941a509f3c2398a8ce0945be36974ca3f3821a738df3c52d1ad4b121ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa412a941a509f3c2398a8ce0945be36974ca3f3821a738df3c52d1ad4b121ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa412a941a509f3c2398a8ce0945be36974ca3f3821a738df3c52d1ad4b121ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3fdfe0ea34671f1deed38a3227bf7dc097c7aef909a71e0c96ac6ae984dace9"
    sha256 cellar: :any_skip_relocation, ventura:       "e3fdfe0ea34671f1deed38a3227bf7dc097c7aef909a71e0c96ac6ae984dace9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce09c12b4ac078a3b3f8d603ee282887bd6423ca71daea045c6ef572d81e866d"
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
