class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.21.0",
      revision: "3c7e6079df558774f573beba39d31527685b6001"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1949aa2595c3ff1c8efe4ccef8eb84ccf28305c08e0b80f765e1b21c3994126a"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef9b2457589f04448bf7969f40a8e5824834dc3857ea08b8ab5bfc970c3c60fa"
    sha256 cellar: :any_skip_relocation, catalina:      "e2b974107b34a4e8ba570476c9c7accf5dd590d9d616c6344d77b49367ac0751"
    sha256 cellar: :any_skip_relocation, mojave:        "5588293186d9bb1332ceb06b5c095e983c6d630fa2918d2d3cf7c3f89fec6cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d9ef4d5836790749356c7f59e1e61a55ecdf60d92119c29c7721ee5f7c787cb"
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
