class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.13.6",
      revision: "7b54511757e327dc3aa17e8ab5bf69d13c398631"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bfd37b4a15bbfab1b8dede1ce2b7238451f81f0e08a6b6bdd440e63dae75914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe529f1a26f2a9305ff5574a996057db01468d6e10518ca39217b9b976f610b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "809ba2b3ffc013b59d07390abcc4efb499dd3782a74b6104dbbb6791a7f9d5f5"
    sha256 cellar: :any_skip_relocation, ventura:        "bdbde53a0f2be228f6dee4d30bfc934935235d20dd6a333a9e651c9aecfae605"
    sha256 cellar: :any_skip_relocation, monterey:       "7c4fcfd7033084620842a78d10fd4150ea01ff74c5aa59a3c5bf441756b90c10"
    sha256 cellar: :any_skip_relocation, big_sur:        "182135e699e1e3b206999233dc22d87528bf400597defabfa3bc7f1d263b2f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "908e8254315e5d86c7fbfdff693c3318d61c39f2eb0491c249b4e9ec1368d4cb"
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
