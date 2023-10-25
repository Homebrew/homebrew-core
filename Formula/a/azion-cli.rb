class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion-cli"
  url "https://github.com/aziontech/azion-cli/archive/refs/tags/1.5.1.tar.gz"
  sha256 "05b60ba56ea72b35feb28e91e17b3c9fc5eefdee8e65eb2abf9ac087b61c1d07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e820dac83346f9ea19d4f67393a18ceb56d39bbdfb4fb4f85ecfedaeedbc5e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "349b2f77c683b9c98decb300a34ed56fa2944dc5849d0bf7922c17adcf200891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "443143e6dff8d719e874417369fe11d61f645dad888552da7dc9ffa76e0bd249"
    sha256 cellar: :any_skip_relocation, sonoma:         "15aa0481bc097bdb6aa3f22a2c3b7674145095d5ff024a340a6637931dc4dc0d"
    sha256 cellar: :any_skip_relocation, ventura:        "492048274292da4e26e05296abbcfe9506ada5d06f322d2cd973367160b39c70"
    sha256 cellar: :any_skip_relocation, monterey:       "a8f04648cf7db8a1c48c90c3112d4c44edcbbe9af3da151da26c2efe347dd286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b16233d5bb1dc092b5337ca1749a9292b470dcdc0e06fc00587ad38c1225b78"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://storage-api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api/user/me
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(output: bin/"azion", ldflags: ldflags), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion", base_name: "azion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion dev 2>&1", 1)
  end
end
