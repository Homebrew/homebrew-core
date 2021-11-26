class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.2.0.tar.gz"
  sha256 "8eea232ac0eedfde49f85278134270066726393d876fc5565e06544b51fbace6"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082b5f0f688fa66d38262710a2eb0c21bca2a9acdfc011f092bdd6d682487057"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdc15f7414dc7c1fd672aa523ba2259721a585cfb49a9232862f0ed8cfd4f9a5"
    sha256 cellar: :any_skip_relocation, monterey:       "5f5a00865ce2e7a58ecee0c01e05d52ddd3b5b61890c6ca215c665b6d416d7af"
    sha256 cellar: :any_skip_relocation, big_sur:        "a43a87b03baf34bd66365d03ec935ef5113c659d3698b851eaa30aa666604daf"
    sha256 cellar: :any_skip_relocation, catalina:       "46853f9bd4dc67da86a70b5686b28fef6db15ef5ffa18d9f8114e8aa972517b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f8596f509ced7b5ca401b8817ed777af8894dff8e33516caac0fc04849ee9d5"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
