class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      :tag      => "v0.13.1",
      :revision => "72c5ea94283ab48cc6c2b7e91d7c901af031ecb3"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eb2db3382c70bfc6decf386bfe901b9e9f2e0319768da4a31cfecebf3bb523b0" => :catalina
    sha256 "6715f3635314af566c04869c3e36369a895754f6022f0f06eaf6c4d79a4b7346" => :mojave
    sha256 "f448aee1de3d242ea718a605dcecd55f6fdc01af2dc233dca8c3278c8bbf1fbb" => :high_sierra
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

      system "go", "generate", "./pkg/icon"
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
    kubeconfig = testpath/"config"
    output = shell_output("#{bin}/octant --kubeconfig #{kubeconfig} 2>&1", 1)
    assert_match "failed to init cluster client", output

    assert_match version.to_s, shell_output("#{bin}/octant version")
  end
end
