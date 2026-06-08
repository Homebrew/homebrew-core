class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "140f9a26191f3d309542691234bf8ffcb94fbb273c8001585f29aa17b2b5c30a"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/flowpipe.git", branch: "develop"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d5b657b21b15c940acec6238e0cd89e895036eb450256ea6752dd2c19da3376"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01e80c290be97bbf46151c1d42045794513ee105154ff7334386703c490009f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caa879f469cb72d16e8b273294d389b8dcbe62f1507d88d6cc9213dd8d5dec17"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea0c62140f48a01c8a04c169db845bd0c43899effad6120dc5d3275c5c9074de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6af786a07fd488e106a0af054a1aa2fee1284660c716936765dfe784decb0919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71bf954a39d61804ee4d312b4a8bc052f588921f2569f6cd6f9ad9c1e98b136"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "ui/form" do
      system Formula["corepack"].opt_bin/"corepack", "enable", "--install-directory", buildpath
      system buildpath/"yarn", "install", "--immutable"
      system buildpath/"yarn", "build"
    end

    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X version.buildTime=#{time.iso8601}
      -X version.commit=#{tap.user}
      -X version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["FLOWPIPE_INSTALL_DIR"] = testpath/".flowpipe"
    ENV["FLOWPIPE_CONFIG_PATH"] = testpath

    (testpath/"flowpipe_config.yml").write <<~YAML
      workspace:
        path: "#{testpath}/workspace"
      mods: []
    YAML

    output = shell_output("#{bin}/flowpipe mod list")
    assert_match "No mods installed.", output

    assert_match version.to_s, shell_output("#{bin}/flowpipe -v")
  end
end
