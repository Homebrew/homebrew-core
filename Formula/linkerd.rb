class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.11.4",
      revision: "7b3ebd22d57b300a4baa7f11356fdd8353ae72e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0911e9e4bf37ea6f617a0b1c126e96ed4e2eccc66f50e14eba9d556373df3237"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0da2791766cbadfc8d8a43361cc11f21265a5493fac2e9133e5f08f696651885"
    sha256 cellar: :any_skip_relocation, monterey:       "29e71f22697d1584acb9e5520c9df6488681ac3603980f3e8c416d3cd742206d"
    sha256 cellar: :any_skip_relocation, big_sur:        "66d9e4158b827ed7065cd8229ba1aafb87d898d441eb27882a6178dbcf4c456e"
    sha256 cellar: :any_skip_relocation, catalina:       "f353a7f4b04a28af8a8b28bac03b979f866d5470bca0d90255b6117563c73892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "292db5d02c6787d77e81029ce860d06760f9b2822b47fd97e98c19c733bea615"
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
