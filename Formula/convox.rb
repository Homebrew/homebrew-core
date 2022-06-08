class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.5.1.tar.gz"
  sha256 "4220ad93e5e5028c080f140dd353dda9fe74975a39e4a6c1218eabfd11156c42"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4960f962536ed9497465e43d06861c7edcf72c378f4dd6d7ce5a28f70f4faa69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b564b17831d6f289ae4803d88a7c9cc1fd8bcebbeaa301b1fa4b0b7d3a7908f1"
    sha256 cellar: :any_skip_relocation, monterey:       "4a3851e4a32aaaf37f82b4a0b2b1c57408743137f643ee120dffb1145bb79ca2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1906cfaaa3393df25b0adcd21553112790e718f2534a774277ffa90e1f797406"
    sha256 cellar: :any_skip_relocation, catalina:       "f97f14ee98931650bacd57583d1117ef0090f9a85e1291e74e928ebcffce2513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "290d2fc2b019243533f064659ce16bb2b58c72ba3b2b910ba48c5f5f8c8e78a1"
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
