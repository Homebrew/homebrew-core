class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.18.0.tar.gz"
  sha256 "2433b29119c082f9ad789555a979dedab8aba21df09df8520f8464ae7b8688ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36bddde4065b299e43942eabafd7ec4aa2ad2740d300c3aa64a0543a843e918e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7791260f3cb188ad1d1283e82d9ea35b8d1f4f4f9bfb314b93879a787ee67284"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c1ed8851f59011401e737a6490b34ace34bcd9d677b7073e143801fcf92af86"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8dbe1aa3387233f2fdb2fda8a26d73586718f3be797d6ca59ea20c4d9d35e43"
    sha256 cellar: :any_skip_relocation, ventura:        "171199825828fe509ab4f55f3c26fa012fd015c108adcd96fec762efec050694"
    sha256 cellar: :any_skip_relocation, monterey:       "2305ab00db7bd932273ddf2dd6041ffbeb7c829b1756319321e238f30f8cf93f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94ba335cc5f81a0a35b838d795bbc271bd1f775fe9a642a0e09fa8590faa478e"
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
