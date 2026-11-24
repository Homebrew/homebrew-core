class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.356.0.tar.gz"
  sha256 "dd3ce1f471099ef68247549d212383cc120f9758d939b0ed85337161b3718db5"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    manifest_sha256 "7737f9470cca0eadfdb072ec55b389b508b5328ed8538e85776c5ef5deaa5c05"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "490587b472e135518c9244e7a48d158a62a4ea616791191539b200f84afb415c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d74b3e059b1882d608e84c0c8262d1e5c2aa1da377394ba67767a9dd5c58f325"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01982b4a2e838a45595ac48c1bdd362272034dc773a4610b3f19bce530b3c4ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d9e30f6340286563ca011b15797717c73fc4075a33f7ccf57dc4d15308f9ede2"
    sha256 cellar: :any,                 x86_64_linux:      "18ee7b4cd123736d5cf5718ed100553a8193ce715016967d36b43474462d5786"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end
