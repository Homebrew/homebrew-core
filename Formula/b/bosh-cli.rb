class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.9.14.tar.gz"
  sha256 "761fc707b625af36f7d95c7624a09478c6e728c29f524cb16f7a1ee435a40142"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be5803388ba75e45333a7f295ae7baa1c39a24237fdbc1e131384e25c7beccf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be5803388ba75e45333a7f295ae7baa1c39a24237fdbc1e131384e25c7beccf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be5803388ba75e45333a7f295ae7baa1c39a24237fdbc1e131384e25c7beccf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c1876ac01591a828495af0bb1d11b3fbfa0d5410edf1358c9280735e57262e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee1b0681e06dbff4a57da12c11f38a64210185d069a6a7bb15b4ce564051016f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e80d9721469d68c62701588eb1dcfe5023a204ff7c3d46153523f447af129116"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
