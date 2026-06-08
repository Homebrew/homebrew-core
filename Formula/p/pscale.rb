class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.287.0.tar.gz"
  sha256 "6b2675a61312d5604c1118f41217638442fed4f9c836a6a6862cf7dec77a64db"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b08726f4e6eb3db964fecbaacb4d28e9de1ca535e5f6c6d00dbf28f12f321abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36e6e90c093dd9a489afd89e131fba872c9c8187ee6f97205fae6ee345490a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97e2ddb84861df10ae0a16d6d0a45f351ae1a5c656ed305a4741a4b84afead35"
    sha256 cellar: :any_skip_relocation, sonoma:        "64694eb86f9ba7ed20f211ab3ce23c7ddd965145a1885a50312a3848fdf69b12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3fc5e78142eabdeab135ae881b325c201fe463d510433f55927493d9935c5c4"
    sha256 cellar: :any,                 x86_64_linux:  "da3d7322a4e9154fbb951ad04324e6e5a5b51992a6895607e90daa0b2235bc17"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
