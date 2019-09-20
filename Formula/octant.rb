class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://github.com/vmware/octant"
  url "https://github.com/vmware/octant.git",
      :tag      => "v0.7.0",
      :revision => "632f678f1706ad6ce3e725e30f3d267d7231b136"
  head "https://github.com/vmware/octant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c3f8a3f5d2f8888368bf6f24c0b28c4d516ed005c3c5aba3c485fc72eda1414" => :mojave
    sha256 "b60233f74ae10e0b5bdb3f7003676db10e2d8daf177ddd0245389521001379a6" => :high_sierra
    sha256 "bcab9204ffb24a70f5a9d838c1494e932d641c281b5ba6c13a87ab4aca90ebd3" => :sierra
  end

  depends_on "go" => :build
  depends_on "node@10" => :build
  depends_on "protoc-gen-go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    ENV["GOFLAGS"] = "-mod=vendor"

    dir = buildpath/"src/github.com/vmware/octant"
    dir.install buildpath.children

    cd "src/github.com/vmware/octant" do
      system "make", "go-install"
      ENV.prepend_path "PATH", buildpath/"bin"

      system "make", "web-build"
      system "make", "generate"

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
