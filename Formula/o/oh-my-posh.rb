class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.9.0.tar.gz"
  sha256 "c09e14092b347993dfcbdb7be825fd285b9b4ecae957023802c1caa2ce563a2f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7a89d626fb30961f38d0c476dcc3573148163e01f7f76bb1cbffd2cfefb0b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40bb187a2289c6c954d21fe8ba6b4dcbfd79fa27c03c37b1abcfd7637f1a5360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dacca3494851b0b2f90cbe0e8a082e533c38aae8f820b2e7351d686302772e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "759dbd4d4e487ecff9c880e2a12641fe86f5e87367085c878ff888b46e915879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c14e87a452b4e174d750b24c4b6dbb562a1a902cc6ae19ffee47cd2ff363450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "609fdf3b040b80852772bd676a986a64b241583d2aefc74a4db88f35d1dd17e2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
