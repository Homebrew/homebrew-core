class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.15.1",
      revision: "a7c9de866fb34d97034d41bcc281ea40ab256988"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "460697110b26cf9da4d31c9ab41d927fb25a2ca1e936ba007193c1f595eb059c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "599d7a3c44e940f7f035600fefd463e03f8b395d350f27cb9d73ac805cd19fd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88aeb301df5606aef7dbcfb6720bcd3bd2ff1735cdab992f762c88d24a2e5d95"
    sha256 cellar: :any_skip_relocation, ventura:        "9b47ccf2181781672283a4c0c4e822b6633012b55bde32f5d678647702b62f3d"
    sha256 cellar: :any_skip_relocation, monterey:       "5182f383a67e16e22b076f6ae12162a1c05e5798d106778b3f298518ff7a1e97"
    sha256 cellar: :any_skip_relocation, big_sur:        "0875d3c35d730f21396c81d541fce6e4047e0da9a47d2b1b01a35d490b9df99c"
    sha256 cellar: :any_skip_relocation, catalina:       "e5a6a961f24f3a1a8c0f4b5cbac24566224bef68c1ec8eb9de414660f68cd276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1404ff1fc139efb8467e22ddbf9d399f997994ebd375ad6bda628ab6a233b324"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
    pkgshare.install "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
