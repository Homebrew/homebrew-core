class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.357.0.tar.gz"
  sha256 "d77ffaf1a517266b936a882dc6eba8551aa27780b18e40ec70234bb4bcd4bce2"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    manifest_sha256 "80c28a75bfab992c4116f3113787517e788f390a0e37ede3ae117aa1f3ca19cf"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27db3fe9c05f34c79b22795d6235ad990fe3ba30a0a3cec64be8098d0112458c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc1c81b63c250779ed0666418a2e1f5e724fed9830fb5dfb310ade7f2a7a4212"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0519bf8648d44cdfc1e2dc1beb6c755a9da600927fe0f54dd40c70d600fca0c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a09697e76efb23369a2f9657abc48ae4de1b38fa70e885e4b078d76121ce2e02"
    sha256 cellar: :any,                 x86_64_linux:      "9a3c396c302040f0941107e847020621f1db38794d42587f228346a8c7e70808"
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
