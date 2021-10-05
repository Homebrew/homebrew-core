class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.11.0",
      revision: "02064b02fc913655783e05caf7210fb1e8cf020e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f24abf0fa75860523155127f372b718c1f70015c1929fa58ac56cd037ac329d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "a3d1e5b47ea8c6e0b1e591bf8793036f56d669c3a84a87d61f17096bc6023927"
    sha256 cellar: :any_skip_relocation, catalina:      "216c9582db9a0c44543e1bc720cbb7d8a414fb2804e97ecdb5b6d643e5537b9a"
    sha256 cellar: :any_skip_relocation, mojave:        "e26dd71cfa2cdd85a8a6fe91bf8fa836f6efa5f953532b200b5b581a4e09ba49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2826a7fdb324368e5ffbb756cf917cde769a4e7cbd930ddb9026eaccd108dcfb"
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
