class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.47.tar.gz"
  sha256 "09ab5037c00984e737d2a0e5b9ea2413847af04efb2fb3b734d77747a87f00ba"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed66652cbc79f26f26cb9120e3d096f9e8c03147319f2dd6086c27e674127eb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "397c2418864670cbb4314b526cdc69e47877c6f492a95e96b0441f961dfb6599"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ac11d7e7570f8d2c50e2d36fcde9db3e44166f18f0c3d023c75b83bac247822"
    sha256 cellar: :any_skip_relocation, sonoma:         "5043d7b9a10d57844969fa099278b4022154b571755121e342e59ce8387be421"
    sha256 cellar: :any_skip_relocation, ventura:        "4ae04b42a7358d3df7db73ebf74ca965b9ed93ed772587f0255a7f462c134b72"
    sha256 cellar: :any_skip_relocation, monterey:       "fb572da933b9d7e56e1f90607df3547ae2b2d7f7faf797ade44c61b22fa5f4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be2c96d81a04c0ebd8cd0a10c2e7947adb7d5dae08dad441623b7b6d979e10fd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
