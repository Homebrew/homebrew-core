class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "version-2.19",
      revision: "0ebd74b02665ee7206490901703ba50949121af0"
  license "Apache-2.0"
  head "https://github.com/linkerd/linkerd2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29314e30f4ec8353bdf22803443f82971e6405e328df651f8457f8fae4412987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e0f392cb3721e4ba679cac8dee7e64f39a28ac0da1184f7ef170adfd159348a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e7ca39e9bea70672197c551bc99d86aea5ae363998bdc07809c97af352b6507"
    sha256 cellar: :any_skip_relocation, sonoma:        "737551ea4c0faa1ccc5d6748a5d64034afaab40d3580af9c87212dd8141b61e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1213189d000496649fde742f2e625335dade2a96f29810698f66df96572a3bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7bce9787bcdaa80d6681d17e05394e03a4c6f44fdc0f337e189c4395a862298"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
