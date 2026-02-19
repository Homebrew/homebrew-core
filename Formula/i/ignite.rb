class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https://docs.ignite.com/"
  url "https://github.com/ignite/cli/archive/refs/tags/v29.8.0.tar.gz"
  sha256 "c5fd0ce010272e7b1677c99f0e60c75b70f3795c414e6ab4e5a65dfeb6eb5458"
  license "Apache-2.0"
  head "https://github.com/ignite/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b774a29241db3fcf464b6700bedec1120a173de5c53fc814caf88ec91fd25e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea00aa2f775064ac1995e05d4b529148b9d033308982f2e015c499431e73c7c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6112ec34ad6b27887b4d33237e9262a8afa795aea880f546dcfc2e81dd3d260b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ff6017888c87eb1d44eb80565b886c2af4852169cb1eaeb01c153c2b8bc77e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4179a3684a9ad8fdef3914a35e09edbe31116a414d920d0374dc237fd5086171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "796c244de0d829efe894e1ceb6254975d13fc3c29f6d7e24dc3cc76f8377ae53"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin/"ignite"), "./ignite/cmd/ignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin/"ignite", "s", "chain", "mars", "--no-module", "--skip-proto"
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_path_exists testpath/"mars/go.mod"
  end
end
