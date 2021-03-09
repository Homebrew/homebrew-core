class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.17.0",
      revision: "7fded9570239df80f75fa6cf9f4a6ec17945a7e3"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23b00a85b2e55227064438513170540974ad15e41ec61381eec81b34347c6fbe"
    sha256 cellar: :any_skip_relocation, big_sur:       "7aaa68d4f40aa80157ebd742f8c2daa7e6669302adf2caed6574d28ef4e09ddf"
    sha256 cellar: :any_skip_relocation, catalina:      "553b8b8dccc524c09141fea90a62c4c11a8dc26a5c7c9996e4adfe8be2041e85"
    sha256 cellar: :any_skip_relocation, mojave:        "674f1f38df2d07bbd9f0aace72b5258b5f08ef604dd57c4a6ac2533298357a32"
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

      build_time = Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
      ldflags = ["-X \"main.version=#{version}\"",
                 "-X \"main.gitCommit=#{Utils.git_head}\"",
                 "-X \"main.buildTime=#{build_time}\""]

      system "go", "build", "-o", bin/"octant", "-ldflags", ldflags.join(" "),
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
