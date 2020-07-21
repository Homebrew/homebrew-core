class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      :tag      => "v0.14.1",
      :revision => "51ce7f6a7e87c9cfcabc9bf402dff7eda5d6986b"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b154776910a741c19c20adebc5e4580b3c9c9a9fca032587fdfbb8ae3ae69f0e" => :catalina
    sha256 "fab43c391f9844bb1243680b27d24530e56be8f65c1cd5a0168f254d3fb16ae5" => :mojave
    sha256 "e69dc89615e2b9b8f835dc28f237d0291365427fd7800cc8e511843d695906ed" => :high_sierra
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
