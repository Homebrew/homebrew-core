class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "21f1f6b0bd484547d94b9bd6db005812968c4c0784fa2228f7cff0da56ccd95e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7604b029f8a4a0ea48f26274cfbc550d258fcd446e2bfc6288f86716132ac550"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a7e66c5eea1ec50206654c7267d750139ebdf99614e9afedc76164f2f208699"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb9fcddc36e7294e7f84333f3c4b4e1b00626eb6ab33362c2311f6ed0d0a9259"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de5f50ff8048be290b36092fcd890b85b672a4286183a2a1cb0771cf60c0412d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff20f9941e5e7b7effef9e3f0d122f060893429c9c933ec3721c145fe7342bae"
    sha256 cellar: :any_skip_relocation, ventura:       "cd4417405a3224f626a5ce80074bbed8735b31a8f2d56467692d7dc6bac3d4b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c75b403dc102e00429d8ac05a925d72253e373947ff608db5a8bd3e005a10f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c9b2da386e4f32aa027f6f91451644838b1d69eb5cbd3e6d5424b2c9dba229f"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"

    system "corepack", "enable", "--install-directory", buildpath

    cd "ui/form" do
      system buildpath/"yarn", "install"
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
