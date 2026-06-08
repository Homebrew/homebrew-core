class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.22.0.tar.gz"
  sha256 "a5f971d2885c0af4e225a31f1e2a7e2fb614e8141f709fd667b1e1f3b9dbda64"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61d478763e42a398801a83870ea0904605304fb669ed2605a8907fa383cbde70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61d478763e42a398801a83870ea0904605304fb669ed2605a8907fa383cbde70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d478763e42a398801a83870ea0904605304fb669ed2605a8907fa383cbde70"
    sha256 cellar: :any_skip_relocation, sonoma:        "d408a28b47fe3ba16952c7666151d770cb9fd0f6745afe5ef72be64f4683a988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64b6e0f5a02fcb0fd2620f4e2f5b7f779057beb40f142641ad26d7f24966f410"
    sha256 cellar: :any,                 x86_64_linux:  "7f267e26a751ce7799b5871690f339ac5f7d6e10978b9ef8061293761964152f"
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
