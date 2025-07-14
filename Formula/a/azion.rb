class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/3.6.0.tar.gz"
  sha256 "4a9df4e895a5c1e284a5081f6a529b575d8f18bbbae40086dba686f006de4654"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8efba93319b81fa85bed2d35df98aed2c977bd33a99c8a20ec49da2c62a4234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8efba93319b81fa85bed2d35df98aed2c977bd33a99c8a20ec49da2c62a4234"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8efba93319b81fa85bed2d35df98aed2c977bd33a99c8a20ec49da2c62a4234"
    sha256 cellar: :any_skip_relocation, sonoma:        "371d05e85189c2ad5a7f06a8e6f70e13714f3b6a25bcf3520616828ed9a892ba"
    sha256 cellar: :any_skip_relocation, ventura:       "371d05e85189c2ad5a7f06a8e6f70e13714f3b6a25bcf3520616828ed9a892ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60ca8efce2985b520fde74b70dfc5dbb1bf357c5435762de91192399abdaaef5"
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
