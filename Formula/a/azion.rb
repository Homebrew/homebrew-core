class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.18.0.tar.gz"
  sha256 "be0cb8052dda7be1593a6ea79666324866391e76df62959a02ad5b55a1889722"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e3bf077bd910a4214b34cc14c9f98681a69dfebfef8e1084551ce52af128acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e3bf077bd910a4214b34cc14c9f98681a69dfebfef8e1084551ce52af128acf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e3bf077bd910a4214b34cc14c9f98681a69dfebfef8e1084551ce52af128acf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5c94b30061391ecaf424e4ffd0224d5d9d07c964d1ddfbae5ab70c84cae0cca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d4daa45546fd587b3e0a56fc5e8c268008e37850405db24148aa43017775501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2788bddb1ad2078c3bd5729021d457a081606e82cc8be1599e9cff32ae504c6"
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
