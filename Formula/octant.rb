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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c435e4f142c85b926de9bfbf0d45da7b4331695d5a53f923389e6cbd72413f82"
    sha256 cellar: :any_skip_relocation, big_sur:       "62c48472df47c455ce12db4064df940e340c037b2d1de4756db6eb377367ce9d"
    sha256 cellar: :any_skip_relocation, catalina:      "e9cd027616d285b9c9225ef2ba61af398654a7417fbe1761266ad875756299bc"
    sha256 cellar: :any_skip_relocation, mojave:        "6b5c2322f973325527b4b5a0035f445f7b46368d5a5ccb08b631b677e0bbb416"
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

      build_time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
      ldflags = ["-X \"main.version=#{version}\"",
                 "-X \"main.gitCommit=#{Utils.git_head}\"",
                 "-X \"main.buildTime=#{build_time}\""]

      system "go", "build", "-tags", "embedded", "-o", bin/"octant", "-ldflags", ldflags.join(" "),
              "-v", "./cmd/octant"
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
