class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "9ef3a35e764764acd9e83ce85b6f6cf126189da83c08d2dcd6ee65d226664c12"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2158c406bb23fd50848cd194ae268334091f7dc0f833cf84126136fcd558882a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d1ec458fc2f19ada03dc870f32a2591826a29784338fb376f924195e59e4ea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd6eaf4ac04de74f92bbcba0eeee3a597f5081abc7998ab911879b3af2be619"
    sha256 cellar: :any_skip_relocation, sonoma:        "587f6abff4e2b55e1f9c1f53342728209a5272ae07af0771f9f54a37d91dfb4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59d36d72a1b888521f2ca809fda9f2f3f11b589cc533c1fd7a0e24f1c6034856"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a069fd0e32d8fcdcbb57ec53b43cd810d7e228b5072b367ac54c42e107a7e8b"
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
