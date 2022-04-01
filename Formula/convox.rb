class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.4.0.tar.gz"
  sha256 "11d61f80534a20e384f3a7d905b38049dda2bc3c4281996f3d3c32c757121029"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "576b5b4c9a4fcbfce5adb80d1a2f91eab0cd3b4ba4e8c044d4b58d2bded13515"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31a92bf542a49d6a07c6bf078bedf40bfc1886f4a2e886eb5a3373ee31404756"
    sha256 cellar: :any_skip_relocation, monterey:       "1b42339e1c0976298204842c94ae37f096fbe8ca6fabd1c0e4875695e9e901ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "00bdb1e847fec02835493c132e60966d40b94c4382105a64fe1c206dc6d1f97b"
    sha256 cellar: :any_skip_relocation, catalina:       "c55238dc62237251df8a502e38d0f33f62a6c76ccc1303de950151eeb4176f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b52606fe29d4bc86407aa7b4eccc2150acb81863f7ab2a6e22892d0dd5a3bb"
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
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
