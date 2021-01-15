class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"

  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.9.2",
      revision: "d5e9d56ce431bdf5ec02e51461ec0cf4bfdd783c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5e1d514e823f835f30c245dbc2e2d115f287ccb60f25d33335e7aaa71adf4ba4" => :big_sur
    sha256 "0ba475ac36c57ec4d82b799e1b087f338b1c2672c7447cc5a4bc253761b9325b" => :arm64_big_sur
    sha256 "42d10f369486219dfe203c4a219310be08d2a62250e31ddfb31668921204fef2" => :catalina
    sha256 "972c9162520a936baf72bbf3771a52f5698f15903cd7418724cfcab008669b9a" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install "target/cli/darwin/linkerd"

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
