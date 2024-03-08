class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/1.14.2.tar.gz"
  sha256 "98fff2b7122dac8b5dff9ab9a795c86dcfd2f9868ca8e33826a78f6567825ce7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87085ac6fd1909de331072da34ea5749165ca84573c02b8607ac5324194ed97e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ab24e2e47428b73e3e7586152485fc0c1b6c77c460e7b4c33def995cd243280"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c3eaef08b0cbf5c615942db99e26ce58239d308abd2d0a6625b61fa208875de"
    sha256 cellar: :any_skip_relocation, sonoma:         "10da604a8073b5d348174d69b14c8231179eecd8a9db9f08c86feec673ab86b0"
    sha256 cellar: :any_skip_relocation, ventura:        "5f0dc4a5b71bc82124d86994493c13869c2e03618444216d43c77bc6a9493de7"
    sha256 cellar: :any_skip_relocation, monterey:       "ad2b52ff83d300cbe7700fc6fbe0cf80124441d3a981ef827f3b5ef6ede017c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bc1cd598170005a74fa72ed74fc23a809fd806667af9fa197034b5d5399143b"
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
