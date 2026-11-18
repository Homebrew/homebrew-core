class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://github.com/planetscale/cli/archive/refs/tags/v0.354.0.tar.gz"
  sha256 "9156335c7fca6c257004a7770eebb61aff4311ab4d1743d3a791fdefada16bdc"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "173238bce0f71ad8c17f6cb17c7da24df17003aa6bc471f956f3593ba70921a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0abbf1b0f777dab57333cb25b06282cc4f5c1c1702542fba19d5af892a1f556"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "04ad77ff5687e692f5e565116e0320b594c8119e9a4e933ac5fa6a88fe06fa24"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "70f7890bc1240c6938ba26c5700dd4d7b63d07268e9eeeb37dba05284b741482"
    sha256 cellar: :any,                 x86_64_linux:      "88167802aec336f98214f0958f4449acd934d759cdde8b02446c29b3705b41b8"
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
