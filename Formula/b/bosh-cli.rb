class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.16.tar.gz"
  sha256 "438d8b9a6e4ab1734de8babc95d1feaaad59c73771224a9fe150806450fcb0c7"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41af824bb298b330452b3c2acdba76f2cb545d2cb25f98d38ec23acd206073f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41af824bb298b330452b3c2acdba76f2cb545d2cb25f98d38ec23acd206073f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41af824bb298b330452b3c2acdba76f2cb545d2cb25f98d38ec23acd206073f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "435d2995ddcdf022d565d88a40fdc71f9bb88c7237681dfa29466957393f2e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45bad7c94e7a3afcbbfa077c21e4fdc52df6f84cd9c999dab285863122600f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a21ec3d87f5be342d6d877984ce883847bc0fd6c583b20121b8b176e4ce1cce9"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
