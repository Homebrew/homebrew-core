class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.9.7.tar.gz"
  sha256 "844f600da305577db726cd2b97295608641a462a5e1c457de14af216e4540fe4"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8e7c60bcc9a1b2c6eea9316b9e60fe63d25b22517c4dbc25eb60698792e46f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8e7c60bcc9a1b2c6eea9316b9e60fe63d25b22517c4dbc25eb60698792e46f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8e7c60bcc9a1b2c6eea9316b9e60fe63d25b22517c4dbc25eb60698792e46f2"
    sha256 cellar: :any_skip_relocation, ventura:        "711eded2ec27e8031c01a2f3a6a9a63fe68c14b6e3cf675046a410513ff59661"
    sha256 cellar: :any_skip_relocation, monterey:       "711eded2ec27e8031c01a2f3a6a9a63fe68c14b6e3cf675046a410513ff59661"
    sha256 cellar: :any_skip_relocation, big_sur:        "711eded2ec27e8031c01a2f3a6a9a63fe68c14b6e3cf675046a410513ff59661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b16b399d1f49ea2f930f8ed45066528b1916d0423b2aa84f934a1e530a70c40"
  end

  depends_on "go" => :build

  def install
    goldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.branch=master
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: goldflags), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")
    # CI runs in a Docker container, so the test does not run as expected.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
