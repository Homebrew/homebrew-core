class Helm < Formula
  desc "Kubernetes package manager"
  homepage "https://helm.sh/"
  url "https://github.com/helm/helm.git",
      tag:      "v3.6.3",
      revision: "d506314abfb5d21419df8c7e7e68012379db2354"
  license "Apache-2.0"
  head "https://github.com/helm/helm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "449dee347b17a3d23c91446ba928174cf3017a61a3fa940631af9fb5d64a25f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "fd6be8f1be7a5c70d2e405661ad113329b4bee963761913d6d86d66858b410a1"
    sha256 cellar: :any_skip_relocation, catalina:      "2952ac5a7616cde0fdb055a8d3cc1e5d7895134689c7f49c064b32eedcc72d9a"
    sha256 cellar: :any_skip_relocation, mojave:        "6f08477f73cbe14ec64701ad5813f76937f042e61252f7bc5fc3baf1c371e720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c36199f8084a8c81ff3dd53354f7a3a42a062828a66477d28d3faf617991b63b"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/helm"

    mkdir "man1" do
      system bin/"helm", "docs", "--type", "man"
      man1.install Dir["*"]
    end

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"helm", "completion", "bash")
    (bash_completion/"helm").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"helm", "completion", "zsh")
    (zsh_completion/"_helm").write output
  end

  test do
    system "#{bin}/helm", "create", "foo"
    assert File.directory? "#{testpath}/foo/charts"

    version_output = shell_output("#{bin}/helm version 2>&1")
    assert_match "Version:\"v#{version}\"", version_output
    if build.stable?
      assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output
    end
  end
end
