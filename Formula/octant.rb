class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.16.1",
      revision: "8aebb34922f83894fb02ad393740e96ee1b3d8fe"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git"

  livecheck do
    url "https://github.com/vmware-tanzu/octant/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "30a8f2ff4c498c638647ce0c4a223ca1bb7712b940e2c333498b3c66b073ee76" => :catalina
    sha256 "1327671fd6c2658fca5e9d7c2b1cc7be4e7971979dfee9a1867bb5a38ea0e9c7" => :mojave
    sha256 "85cee095a6fcdd835de7ca830e9da0e92b00c0ccdbc9e4af2c2ecd3db91e554f" => :high_sierra
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

      system "go", "generate", "./pkg/plugin/plugin.go"
      system "go", "run", "build.go", "web-build"

      commit = Utils.safe_popen_read("git", "rev-parse", "HEAD").chomp
      build_time = Utils.safe_popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp
      ldflags = ["-X \"main.version=#{version}\"",
                 "-X \"main.gitCommit=#{commit}\"",
                 "-X \"main.buildTime=#{build_time}\""]

      system "go", "build", "-o", bin/"octant", "-ldflags", ldflags.join(" "),
              "-v", "./cmd/octant"
    end
  end

  test do
    fork do
      exec bin/"octant", "--kubeconfig", testpath/"config", "--disable-open-browser"
    end
    sleep 2

    output = shell_output("curl -s http://localhost:7777")
    assert_match "<title>Octant</title>", output, "Octant did not start"
    assert_match version.to_s, shell_output("#{bin}/octant version")
  end
end
