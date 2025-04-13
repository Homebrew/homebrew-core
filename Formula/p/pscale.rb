class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.239.0.tar.gz"
  sha256 "b14a0740ef41342503bd09ac58df4cf0302d9d0355981175e0bbcb427ab14c5c"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69426bdee245c7071dde1f102a2ed1ea48b9a3a2d58af60246d6ac929a2bd3e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27ece1c9cf5c37c8f8cea2a671bfa5df11dcef38746977394c95154561726473"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3336165b88b9bf8ab77981f190e64b1e06621e945da396bfdbd7d0cec5de903"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f93b41beaae778d0c560e60be685c29bba9d0368a4e591437b3794e52bce241"
    sha256 cellar: :any_skip_relocation, ventura:       "81e448410b8881dabdfcb4e8779881bf7b3652285eb41b4018ac39be86dcbda1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2f108296366d09e8a051846612bdfb69c573ae21fc535a9809d09d0786fb54d"
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
