class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "7a73d678bcf32c3694ce01916f9154c07f189705338d9194b5e47a2858fa52df"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9a20a94582b9248e563621840575da44134e7d2668d7e30fd88cba8b7df4824e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "170dc64c328c729ca3af24bf436a2d8ebe9f1d02f91c94d22ae54d1dfa97dee7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0568a41cbd63a05c7eaac28d05cf00b355bd55b577286ff894af7085eb206f9"
    sha256 cellar: :any,                 arm64_linux:       "da62d55897224de31f9c60abe7162556cf3b1a6374cabafaf90e3c1530f8b654"
    sha256 cellar: :any,                 x86_64_linux:      "58950f43f718594b6bf158a2c10ef427eaecdcbff27cbedf9e39b3db22f3f57a"
  end

  depends_on "corepack" => :build
  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "ui/form" do
      system formula_opt_bin("corepack")/"corepack", "enable", "--install-directory", buildpath
      system buildpath/"yarn", "install", "--immutable"
      system buildpath/"yarn", "build"
    end

    # Workaround to avoid patchelf corruption when cgo is required (for go-sqlite3)
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    ldflags = %W[
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
