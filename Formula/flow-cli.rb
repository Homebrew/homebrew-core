class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.42.4.tar.gz"
  sha256 "eeadd32b7aa7538f08981e1ac25330e1ee57644b4434424c883f798e75bf51f9"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b3175875d7bc1403fca4d0882ab641d69390b1f09e7a8553d152fb89e02092c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3211e42e3e46ff0a7351464f013556325f78e7a204cf8e7712e1d0e842d2cb63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e1a575ab15de6d9c475f3b235775477ba1e60c8aeaa71f9ee3b14649d4cf426"
    sha256 cellar: :any_skip_relocation, ventura:        "f79952b8332b85542b22cf417c3dd02bd00ee6065629f55a610293bfd1363547"
    sha256 cellar: :any_skip_relocation, monterey:       "4e6ba176ecc9e4c8ab5d55ee8f2c89210abff48317dd62144fdc3ed5ad2fdc7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c106b9585c752fbd205affa7cb85a92472893eb80837d70f32b5f2d581692e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6eeabb01ab345dec81bd0bcc2d67ceac44480e303423bf806abee6776b677c7"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
