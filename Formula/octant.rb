class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.23.0",
      revision: "fbe2be3b687b3e2199ea32753281c9de1f334171"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c071e032b501ea669d62a91025c2b56513738e70c84d5268d69e41437954f892"
    sha256 cellar: :any_skip_relocation, big_sur:       "bdd354d48a3fc55eaa371badf2aa9085fab75972298c9e45a2fe6ef753dd6443"
    sha256 cellar: :any_skip_relocation, catalina:      "2fb18a44106cbb6c54756951b9355d83de113e8c7fbfb9169af94b5497a42f63"
    sha256 cellar: :any_skip_relocation, mojave:        "e6c0dce913f776cecf1eb5a2ce7c1115baf0a2489dfe2d61c45ff830e4475538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0e1ff4dc41061a0092ac2b283475563f6c636e526badbbbf9b0e511665688ac"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOFLAGS"] = "-mod=vendor"

    ENV.append_path "PATH", HOMEBREW_PREFIX/"bin"

    dir = buildpath/"src/github.com/vmware-tanzu/octant"
    dir.install buildpath.children

    cd "src/github.com/vmware-tanzu/octant" do
      system "go", "run", "build.go", "go-install"
      ENV.prepend_path "PATH", buildpath/"bin"

      system "go", "run", "build.go", "web-build"

      ldflags = ["-X \"main.version=#{version}\"",
                 "-X \"main.gitCommit=#{Utils.git_head}\"",
                 "-X \"main.buildTime=#{time.iso8601}\""].join(" ")

      system "go", "build", "-tags", "embedded", *std_go_args(ldflags: ldflags), "-v", "./cmd/octant"
    end
  end

  test do
    fork do
      exec bin/"octant", "--kubeconfig", testpath/"config", "--disable-open-browser"
    end
    sleep 5

    output = shell_output("curl -s http://localhost:7777")
    assert_match "<title>Octant</title>", output, "Octant did not start"
    assert_match version.to_s, shell_output("#{bin}/octant version")
  end
end
