class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://github.com/vmware/octant"
  url "https://github.com/vmware/octant.git",
      :tag      => "v0.7.0",
      :revision => "632f678f1706ad6ce3e725e30f3d267d7231b136"
  head "https://github.com/vmware/octant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b1affc640b7554ebc5ee2b6bcf02f12130f711021e1f5f2ab16bf17169a7410" => :mojave
    sha256 "71d32a4a152bd00db76c0998fd11357655b784d8fd5fae173f6eee40eabbdd96" => :high_sierra
    sha256 "0a300db48fe21c65128dee5b45ae9a18350a8216e48f658c7b68698c58ab3ffe" => :sierra
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
