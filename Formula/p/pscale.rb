class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.263.0.tar.gz"
  sha256 "95b7535bcb97ed7e06b4c0415f06ff99a8ec52cb73f3657215aacc6e5e80d61c"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60600ffa96525ebe6f34137c318b81526a5cc91a12d126b5a3f82c61a848a986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29a3f9bdb0f7c9cceca58d74e7f5660dd6b4c0d28593a4042205fd4b1dd1a237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec1adb7ccd6426e28efdf6c46f5bdfae25ce2c702935d3703e73ccdf4e15d0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fa2d60cf353e194a9d8c533bbe0eebf7e708fb3d00b239162bf473658a7e301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f232b60f48725bca97713e751894f3022e4adab52f3c553965d806069aaa788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8965bc21b7054278f500cadbddf7be3610981f4344ce0e1754088b97d7359ac0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
