class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "8f68966414428c99a7d6234d5602ab78cc1ac9094722b8a2485d910faf5adeec"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c13dc111980f4b8d53951df3e0a89751343a2cd96706d9b5ef4b708dc1c1a2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c629adf6ea4aa29eddbd47c734c1435f6210beb659a932f9346f350dcc77e51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b28c90f92ef5c9f8361124623e986e6892e245b89e87fc02e16d9764c2c4ca11"
    sha256 cellar: :any_skip_relocation, sonoma:         "c706c277b3437e80f7cca010a4ccca5264adb0d83414f641380ec33714e9a787"
    sha256 cellar: :any_skip_relocation, ventura:        "d52de2eb62c8505cc8516b198eb63a72533786c98fb1f74f6edc0c6be2f75910"
    sha256 cellar: :any_skip_relocation, monterey:       "716c3f4506becc308517e434f21bb50dd00462c2ef7155ee3eb7799f5fa12b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f8734988d7a4971d19d012cbcc195b2358d441d755fb116f4e51d5ef2128b4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
