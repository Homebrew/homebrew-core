class JsonnetBundler < Formula
  desc "Package manager for Jsonnet"
  homepage "https://github.com/jsonnet-bundler/jsonnet-bundler"
  url "https://github.com/jsonnet-bundler/jsonnet-bundler.git",
      tag:      "v0.5.1",
      revision: "451a33c1c1f6950bc3a7d25353e35bed1b983370"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48e0802ff31a4a8650a50548d3d2987f5155bc45e42af1cb707a94ea6a1af467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0e2063b13ad8a08dbfa82dc3ef8507c090ad48295d2e259486d020b016e9bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da0e2063b13ad8a08dbfa82dc3ef8507c090ad48295d2e259486d020b016e9bb"
    sha256 cellar: :any_skip_relocation, ventura:        "cde5b30634858ffcea274651e85da78c40ce57639c823c3b36547f84a7455cdc"
    sha256 cellar: :any_skip_relocation, monterey:       "4c9a5ae896aca771eaa394910f56796c93422988e5f91d25222654ffd5b27ba9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c9a5ae896aca771eaa394910f56796c93422988e5f91d25222654ffd5b27ba9"
    sha256 cellar: :any_skip_relocation, catalina:       "4c9a5ae896aca771eaa394910f56796c93422988e5f91d25222654ffd5b27ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f4a145b4ab60388043e11d940b521396f341281fbaab8c7578fb0b9bcd40d43"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}", output: bin/"jb"), "./cmd/jb"
  end

  test do
    assert_match "A jsonnet package manager", shell_output("#{bin}/jb 2>&1")

    system bin/"jb", "init"
    assert_predicate testpath/"jsonnetfile.json", :exist?

    system bin/"jb", "install", "https://github.com/grafana/grafonnet-lib"
    assert_predicate testpath/"vendor", :directory?
    assert_predicate testpath/"jsonnetfile.lock.json", :exist?
  end
end
