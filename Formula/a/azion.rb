class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.12.1.tar.gz"
  sha256 "15f027a554ee9799c4e60ddf7907ab1989bd9fa61cdfcad0465640fcbea20b38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ebb76ee31907fd2c9b398eb20e8f32113df91514f60de04748c55cd1bd8d841"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cd31a6a2986aab56b2e8ad0fa964fedcc3bbf3abf6128bacc3441c0e9b9a97c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57b8d43d1569190d3820a43e2d029666d759385bbc2be610743d47d2c7082750"
    sha256 cellar: :any_skip_relocation, sonoma:         "b05d6abc552dd1ba5854933377e524c4647404ffe98218a8cbaf60e3bb6ac1be"
    sha256 cellar: :any_skip_relocation, ventura:        "3bb066bfbb7bcab4e8a0e9ae354d029e4fcc35ad55194ad2018cf9a188631cdd"
    sha256 cellar: :any_skip_relocation, monterey:       "97eefe624b4e6f740d63cef13b3dd0b3ba216a320dbacd5fdb77399fae43c963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64da0d2c768350d312093c3c0d22aaa9375595daa428b7a132a36d6232cca96d"
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
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev --yes 2>&1", 1)
  end
end
