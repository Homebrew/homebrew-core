class Octant < Formula
  desc "Kubernetes introspection tool for developers"
  homepage "https://octant.dev"
  url "https://github.com/vmware-tanzu/octant.git",
      tag:      "v0.23.0",
      revision: "fbe2be3b687b3e2199ea32753281c9de1f334171"
  license "Apache-2.0"
  head "https://github.com/vmware-tanzu/octant.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3cc3381d17da6e978da8f398c45922ecafbbdc9801cdae60b02e758d10871b60"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b45f0bc6949efb7dc9c7620392a2176795bf0b7d4f943d2c1994090d39653fe"
    sha256 cellar: :any_skip_relocation, catalina:      "c681f72376bff4283f9c73214f6f26c41458c42295a1bf28107dc31e1a5c4929"
    sha256 cellar: :any_skip_relocation, mojave:        "24c965290843891de8e5ab97aa1824187986fbe47093dbea644a9ff4a2f3e843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72d0cefc011d27ee2f2275c59ee566a17d47999fbcc10612b8055e7083387df9"
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

      ldflags = ["-X \"main.version=#{version}\"",
                 "-X \"main.gitCommit=#{Utils.git_head}\"",
                 "-X \"main.buildTime=#{time.iso8601}\""].join(" ")

      system "go", "build", "-tags", "embedded", *std_go_args(ldflags: ldflags), "-v", "./cmd/octant"
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
