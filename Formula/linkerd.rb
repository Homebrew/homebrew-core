class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.12.2",
      revision: "d1dff27842c5364fe0d03fabc517940b8d7e5805"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7308e1e256ec3108df97d92646741c502a8e07caaeab089695521759acecbaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33d409422d18f07135db4e8b1d847c85b62e611d4e19ceb8690d397a4886727f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33200b67fbd57471bbced08241c5a86c563ab378376e55682c373ef9ad50accb"
    sha256 cellar: :any_skip_relocation, ventura:        "7dca6d91782c5f72a28f915af18abe6a9c71989785b9e61f7b4c3233a4cf9e45"
    sha256 cellar: :any_skip_relocation, monterey:       "b98d167b20f04b3d2e4f3d120f96770e0da3a8b2c29da6a1239d544621f4ea71"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4428b08620995afafe0b669a2389a093998525e576e70be890c85049a3108ce"
    sha256 cellar: :any_skip_relocation, catalina:       "0b515ae45e02873762d2170128d0d27f659e5954b0b3778316b7504ea99bd255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d24a5f9e9f0edf0c2a82f2d4b3e35a5ca5bd91d5b36ada45e1940cacf86765"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
