class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://github.com/aziontech/azion/archive/refs/tags/4.22.2.tar.gz"
  sha256 "249e3a4c7df8b3863671cb8d8ebb88e646a69c336d6628ec6f6c3dc4357bcfc8"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3d01340efd74d1a397383b5b4c4c1530bb69c8fcb08bffac01f8f17ed753017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d01340efd74d1a397383b5b4c4c1530bb69c8fcb08bffac01f8f17ed753017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3d01340efd74d1a397383b5b4c4c1530bb69c8fcb08bffac01f8f17ed753017"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd5a0ef404236570c091e373a2fdb0e698c3760d28f76050bdf2673417d22ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9871d2393796da8ae20baaa01afa78b453a445ae79079d533c284fdf6098f948"
    sha256 cellar: :any,                 x86_64_linux:  "998ecb01faa894245622b81b2c36422e0da267f70dbfea4d407fb32d134826b9"
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
