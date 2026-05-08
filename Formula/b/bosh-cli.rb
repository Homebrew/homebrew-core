class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.4.tar.gz"
  sha256 "ec30286d69a0b12494f13175eb7fa808774be280c66dbb1c5f869423da66d402"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74f670059bfb1ce94ec0122896a289a74d3b83a995138e707647d007c3e1ab23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74f670059bfb1ce94ec0122896a289a74d3b83a995138e707647d007c3e1ab23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74f670059bfb1ce94ec0122896a289a74d3b83a995138e707647d007c3e1ab23"
    sha256 cellar: :any_skip_relocation, sonoma:        "f887de220431fad8d27c47a6e3919a28e0eec3955f1c1022f99b6b8344ba1e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ddbac921008d88f41b82c0104c16b7701bc04a4d9684643aa7edbdb952bdbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc92b742f561fdf30a267067ae84b2636783a165a4722a21c05cd3c0ad5f2807"
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
