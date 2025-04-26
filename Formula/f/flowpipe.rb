class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "fe981ce95de045618264f01728bf59cd4a6f3463e58f408eaeda2f24900a187e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64ae558b8f13d272f295e7632e847d8b0dc157f309335141e2ba60ece28a0a76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69f742edfecdeee9401630cf53d3b92b4247af0eee94e2b0a5fb4ace31bfaac9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e730b06a3c720b30a343a67ab22148cb0418f5d36d3ae9bdbbfa5f62f6017ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4da51fea07766e45ef1748767ccbc35a0f75f645cbed1be7ea890d95909e57c2"
    sha256 cellar: :any_skip_relocation, ventura:       "cd87904b97ce46751c0c7f59214b083a576777809c52308ac297be16d46d3515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "050f55f3d6d0ebb85647e317fb27e10a7c58a61369b42743e9cbb003dc9de179"
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
