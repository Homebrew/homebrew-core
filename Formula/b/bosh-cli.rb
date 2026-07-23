class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.7.tar.gz"
  sha256 "36730c893a0b872d3c286e4413e92e8b1399e2e82474e418c1099b6c9da03345"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6f04b556adfc8bf9cf50d93e35755084808448509cf50400949a327b0940a43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f04b556adfc8bf9cf50d93e35755084808448509cf50400949a327b0940a43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f04b556adfc8bf9cf50d93e35755084808448509cf50400949a327b0940a43"
    sha256 cellar: :any_skip_relocation, sonoma:        "0821aec25dcc01741691f42e01fc2387fc139006c1fbe9e57a2f46f34725372a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "023ebba109294406fe63b6b6287435c8df782855376443f494a568ff82de901e"
    sha256 cellar: :any,                 x86_64_linux:  "ba7a124db06722524c781714626fb1784c941d60f83e0f96961430862174f55f"
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
