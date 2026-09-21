class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.23.0.tar.gz"
  sha256 "4131817e81e3333ff3409101b679351a3bb1068b73898ba42049c802bfb433a7"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc62a6568f4f64c8b49b5405136ce5fd583124ec89855e788ea75915a20151bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a0017b6ba860454b78091e95ccb34c260df037cc748277ea4f7ba75af17ae72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a0017b6ba860454b78091e95ccb34c260df037cc748277ea4f7ba75af17ae72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "0a0017b6ba860454b78091e95ccb34c260df037cc748277ea4f7ba75af17ae72"
    sha256 cellar: :any_skip_relocation, sonoma:            "6b69618014ef2dae68279fbb812a1d4517905c3a3ea229b841de30bcd3c50aef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "053a07ba96cd5102b9fef3e70a715c42eaafbe8ba24594863f2a5503595a34db"
    sha256 cellar: :any,                 x86_64_linux:      "b0cbbaf387b121a2f59c20ee07aac749a2e1192f1b1732798cc0436eac168071"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
