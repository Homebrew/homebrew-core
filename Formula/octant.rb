class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      :tag      => "v0.9.1",
      :revision => "7c4bd4a03489aebba979a09aeda0c4c390650e94"
  head "https://github.com/vmware-tanzu/octant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52126ba28e36f505b3a407bfd217116b57bf53bcfab687fa264e636bf41ff7bd" => :catalina
    sha256 "c7ce2a9e152cb3cd1f7f97392e26d6ace65fb5205a4aa2d8dfc02319edb9b7ce" => :mojave
    sha256 "81dcc583665d254bc84d53b15a357b135a859ed5831a14333c92afc00e9ee28a" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node@10" => :build
  depends_on "protoc-gen-go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOFLAGS"] = "-mod=vendor"

    dir = buildpath/"src/github.com/vmware-tanzu/octant"
    dir.install buildpath.children

    cd "src/github.com/vmware-tanzu/octant" do
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
