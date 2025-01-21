class Flowpipe < Formula
  desc "Cloud scripting engine"
  homepage "https://flowpipe.io"
  url "https://github.com/turbot/flowpipe/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7eaf7d993b4672be9ae9db69678d4b263e80d7524ac486ebe52048b03af2a6bc"
  license "AGPL-3.0-only"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa5432a400489155775d41497e94518cae73c44be1ffa7a61edd6c6f92b97034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "395fb9eb8639b4e94966172e1e37d4e00be793ae7a54321dc604eb26f744f104"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "714cc69fb231a362c880828f99e0fbfc7ae058e22edec97c4ecf153021c07e1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8850931850ac78e4955be5d5e0b39cdf30ccd512ea97b969518ac1203c189bb9"
    sha256 cellar: :any_skip_relocation, ventura:       "72a8372d39112987c5938f03e4770ed929e4aa0847acda2c3a4bc309bb1753b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7454128cb4841b797208d27b1fe325d5835c706f4f1b8a015db8250d58e8a1e5"
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
