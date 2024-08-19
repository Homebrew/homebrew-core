class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.36.0.tar.gz"
  sha256 "31a83ba3f6d9810ad4f4a70368b42ba0f5226d76266797e84351575a6b5a8f34"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c0d650fdc3362aef26ac7a2db8437c319ebcc2cf9c9d5f5ffcbce71ff7b003c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e5db94f577d41c4292abfde87b8cf2aa01fd493b7b61f262b157c2bfb4ba079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3b886ded5bd3e9f37dca6e8535adc1aefec10d4c224cfa7bf3f799af7d36ea6"
    sha256 cellar: :any_skip_relocation, sonoma:         "25a564d1d2134edcd2ccedeb7cd9345c616e2321ad58edb85acac594f13b994b"
    sha256 cellar: :any_skip_relocation, ventura:        "aa4b8a3f99fbb080ca3cad57007c6d9c9de9a8b03a21c7024ac4be3f96288382"
    sha256 cellar: :any_skip_relocation, monterey:       "4939c68220b874172aff2fc2ff0eea2aa2910608f842c9b27eaf90ee5bcef8b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab7e9b6ba81eabdf340cfe395f8a8570308e8e7de5582d6979c09f53964c9be4"
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
