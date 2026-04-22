class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.20.0.tar.gz"
  sha256 "a253b6d83d341723e2162b706180950f2354daddd2949768823d30e3a0512dc4"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46b188695412f90b40619604fca1ddb3358ab0d1bf8cdc76ee70ba2469d59712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46b188695412f90b40619604fca1ddb3358ab0d1bf8cdc76ee70ba2469d59712"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46b188695412f90b40619604fca1ddb3358ab0d1bf8cdc76ee70ba2469d59712"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e8367ead359e92481255c452e238dc893bd62b7fa3e35241875d9b9228b2d43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d7cda065f54f5ccfa0d46b9229c44604df03497f6d26a6b1697f38971ce6bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "271a970867008faf6f7ea3cb5f2531be61c9ec8fa73897c9f557f598b8694741"
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
