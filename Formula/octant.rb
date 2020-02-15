class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      :tag      => "v0.10.2",
      :revision => "438ce3d52088c1e3e15aaf9817ba71e3c85255f5"
  head "https://github.com/vmware-tanzu/octant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "87b13fd410bfa42f937af1f90da746de9d2b775048b088cdb298648fcc0b4159" => :catalina
    sha256 "fb135b41021478e9085f45e2c3f22c73322e059e125c45d89c84804f019caae4" => :mojave
    sha256 "cf44942fad3fce95fee0de4c51fcfb338ee9ac819bdb09d733b3e30e05650675" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node@10" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOFLAGS"] = "-mod=vendor"

    dir = buildpath/"src/github.com/vmware-tanzu/octant"
    dir.install buildpath.children

    cd "src/github.com/vmware-tanzu/octant" do
      system "go", "run", "build.go", "go-install"
      ENV.prepend_path "PATH", buildpath/"bin"

      system "go", "generate", "./pkg/icon"
      system "go", "run", "build.go", "web-build"

      commit = Utils.popen_read("git rev-parse HEAD").chomp
      build_time = Utils.popen_read("date -u +'%Y-%m-%dT%H:%M:%SZ' 2> /dev/null").chomp
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
