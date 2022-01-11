class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.11.1",
      revision: "43fc40f545b47bd86c6800bf3895745f15902e72"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "448be45d3fbe74211bddf2fd1d984bdbbba31c21ba3b77b3f268a7e3af59caee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b43a17a2d62b7ba887a8eef7eeb9a2470c24c6517e086cdc09a0afd606816a2"
    sha256 cellar: :any_skip_relocation, monterey:       "8b7528e2fc919d5e6ee175fdf0a156f961d9d3d3e6461ee3550e2693df244d22"
    sha256 cellar: :any_skip_relocation, big_sur:        "b111cee3a6b809627d8bf5d523a16204cb7e0e6d8805dd61b170f01aef8772d8"
    sha256 cellar: :any_skip_relocation, catalina:       "9382106631b7f7a2a337a9031611d6a34a0a45dacda9456d832aaf18c02ae45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809a13456f459acb6e75778e11d181bf0c1d374218a6d632454a058730aaad84"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    # Install bash completion
    output = Utils.safe_popen_read(bin/"linkerd", "completion", "bash")
    (bash_completion/"linkerd").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"linkerd", "completion", "zsh")
    (zsh_completion/"_linkerd").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"linkerd", "completion", "fish")
    (fish_completion/"linkerd.fish").write output
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
