class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.15.0",
      revision: "97a507c2b071764933bb479007822672d5fa19f5"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e489fb9b13a4515e1969d9de19ff13a03aa7ae0440dffd115d2649dfe575403a" => :catalina
    sha256 "dd1284bed5ad386e94771d44f753a474b84440f5caba49c74ec5f005be3c6b85" => :mojave
    sha256 "41f943d9a1284bd681c0a42ea793e970d3b2b8a677a4af0303a292b63a15d707" => :high_sierra
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
