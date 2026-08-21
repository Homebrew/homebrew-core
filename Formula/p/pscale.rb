class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.323.0.tar.gz"
  sha256 "bd40d3ec99779683b90f2cbd5bb788ac10c6bb650bba92420085c7dca9fac9f5"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "453936c4438db5c632e6fc1e03c6ed8eaf041d95af18c175b7c97a66148e7dc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11edc978168003e8f20297ad9603c854466f458b324ef9f5b0df907b7092b4c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d5cc1f3e32fee99f0a4ce8c914b0e3fec5cd007784257ee09cdc851fba2b741"
    sha256 cellar: :any_skip_relocation, sonoma:        "70334ef93770c7491711fb7780e51ec720c1aeceacd138e5be4f6e177949c980"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1c765e15edf500a2ba586033f368519112e04f2bfd5672285a42b3c06c69a95"
    sha256 cellar: :any,                 x86_64_linux:  "019eb8084eaad876be3cd84013f01ab8140b977eccdca01cb63c3879cecaa914"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
