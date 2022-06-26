class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.11.2",
      revision: "d7a3ddf4bf41babc32aef79fdc5c40ef2bfb9283"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ff7239e59c2dc7df4c0eec295ea0600b9f50934a62c79c800a761b460cf0ce5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4471f37f007e692273b7d728b3c5e1ac777df9c84138f8b6462cea9f5261fdd"
    sha256 cellar: :any_skip_relocation, monterey:       "390524f64fb60db36fae593913f53db00e7d5cefdd17c30a268209b0d3218d2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd681ff6e6bde2b7cbda7570d6be502aefad32999d9cbeb9838d985d4ff5d254"
    sha256 cellar: :any_skip_relocation, catalina:       "b139ca606439df485559376ba834346acd64bc4b8b4ed34bb0e44387183bf054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6616fd9ede77e1942513ba6e615896a65fa6081b16eaa6ce0ea341b9811064da"
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
