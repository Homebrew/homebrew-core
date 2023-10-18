class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v9.0.1.tar.gz"
  sha256 "692a4125b86375e77f4957f80ef815cc757676cd8843a7e45b1fbf12da1a8a46"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea7195f59ce99e18c0abd38b9f4628a8f3d4557628451b98987d3f3c055a5f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b005247d2c3a341467eb2e75a81378be1ed06ac5035b3f2131d6c29a82e6ca38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2814f1faa26f316f34fecfd3a694dda9ad148a736fa319a261f232762c1af43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "744861eed899e8f89638f76d74071ffbd94f72268b81391523e695293d65fbd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "52f5e78a1ce9c6e606941db0f4fd6cb32abbee57e1cf4337902dea241d10f600"
    sha256 cellar: :any_skip_relocation, ventura:        "13a1e95b6db3c6e3334bf585c11786a70427ae9511e9658a6957175aad04caec"
    sha256 cellar: :any_skip_relocation, monterey:       "62850ae0fad8dd4654c5a41051a1838d18893a9c2678aa69ecad3bd3c8acf195"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c7e33b05a1c88a8f5ab8efde32b25391471ebf3522fcb9e55ce28badb838de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b9e7f390166077daa9445ad898a621a1ceaabc390a7b0af365ab01238aca10"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v9/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v9/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
