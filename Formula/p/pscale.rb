class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.220.0.tar.gz"
  sha256 "6c49bbb2668e5a7e60669ac51c953c17c7bd0a95bd1035c75dc36f8dbba2d959"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d845521dfb188b16304b0e456f6a12abd169ea9bd5536529eeef6ffb867682e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e19a59476001bfbb00dcff57e17355dbff58a8dcac9bf589a76be8ef5605c472"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abac5d171e1698c8536e5db9763eb00aa264213764ad6efdb07d9514ade3accd"
    sha256 cellar: :any_skip_relocation, sonoma:        "35fecf65d8c25ab5647bda4da297dd25b644db29e8cc4c4765b0aefbf7659b67"
    sha256 cellar: :any_skip_relocation, ventura:       "45c16c10a378eff5e66e5d2bc841646994610ee11572a79ea2572967529319e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f9a0fd4517dca0adbb677e402a3be2025ab3c4e7d52abbd177a5b81022d929"
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
