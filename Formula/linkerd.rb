class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.9.3",
      revision: "f38ce611f03af8891e1e0d8604cdadabc388dce1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "789baae017bd544ee8761535d050d2ddad5c674832f09c74f2f0739a3b9b3266"
    sha256 cellar: :any_skip_relocation, big_sur:       "4107b12082208ce860eb94d7eba294d9c35dcebec21c419e0943eca21742c4a7"
    sha256 cellar: :any_skip_relocation, catalina:      "86e0b85857dd6c2d86a02ffe09cfe673a45c6d64924cc87e32cf813725ceb2b3"
    sha256 cellar: :any_skip_relocation, mojave:        "ec563871946a601ed88d98de6b3c70d189f2b55c9a949c48b161bf49393d86e4"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/linkerd", "completion", "bash")
    (bash_completion/"linkerd").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/linkerd", "completion", "zsh")
    (zsh_completion/"linkerd").write output

    prefix.install_metafiles
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    stable_resource = stable.instance_variable_get(:@resource)
    assert_match stable_resource.instance_variable_get(:@specs)[:tag], version_output if build.stable?

    system "#{bin}/linkerd", "install", "--ignore-cluster"
  end
end
