class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.19.0",
      revision: "ed8bc93fcd68c6a49f73416c656d97b7341ac528"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93e34686fb232785fd3ac1d129bf2c894e051cd319cbe3e467e88e39f42b878e"
    sha256 cellar: :any_skip_relocation, big_sur:       "36e9b9827682f65037c3a3444158e4141f1683f8f77ca019046c2516bbd871fb"
    sha256 cellar: :any_skip_relocation, catalina:      "d9c994e38bb99a84d6515db3da2c74c664424b2eddf92af57b9ff34597d8f0f1"
    sha256 cellar: :any_skip_relocation, mojave:        "43d701dc172ed5844c50e180aa988c93718ceea6e1d650f51f4553c6188ef784"
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
