class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.281.0.tar.gz"
  sha256 "f56ea067998f968efd423a922f794db4d9bf5b054add78c093d4cd68eb767436"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acba4410cdfb0a72f0c4493023306d6dd26dc93752e866718fa200edbb18043d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "740d25c515a6803c3050151a15ea3ea73af784040d6952990a36157a9455d083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11082bd4a97d26894d3d7cf69d15e5fe0f21094c29c3e9a523f05405b7c89f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ff73d3a1a3a8e642ec8d5e886b94775509902ce06b644297235fe6651ddd709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62c0e8ec7b57b160e41b70c2c336ea3a0f7c26d690264dab3ae3b203b7db5612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d6293ae112a6e887201ce8a4d2361e6c27e59c48b43d773dfcfaf3ad1197218"
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
