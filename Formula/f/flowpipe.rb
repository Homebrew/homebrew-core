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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a32ee434dcf9b4b6c83f7c15ae659baf8ea65d5f8be8d3294b2ff5117d9e9ac3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70bc6f8f2afa61fed554fe1bdd2e0efb9ba4fdca432611e137f86b39e3353dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bba8cb3add69179292bd283a3cfd9a7e46b4bb9f76a63c2b3bb6f1534d03ddd4"
    sha256 cellar: :any,                 arm64_linux:       "ae5891e2ab186b0d29bff4ecfbbf732f9b4a16be548ecc9681e6d5cbfadf2119"
    sha256 cellar: :any,                 x86_64_linux:      "bd6e9080c0183600e96c5464810c826a792b81849cb926aec81bcdfd62e371d6"
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
