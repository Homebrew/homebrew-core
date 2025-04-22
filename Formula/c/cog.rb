class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.14.7.tar.gz"
  sha256 "62d8bb93b9b1488b0dcb576a127b6e84bf17f730372117af8035ee04ce094bbe"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8222df43e96bd90bf2aac471ffa709039951ade023fe269d1aea1da360f31111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8222df43e96bd90bf2aac471ffa709039951ade023fe269d1aea1da360f31111"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8222df43e96bd90bf2aac471ffa709039951ade023fe269d1aea1da360f31111"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddb6fc547e46b0436fb000116f36f0a5e813548aae38d66ff4d5824eafb67147"
    sha256 cellar: :any_skip_relocation, ventura:       "ddb6fc547e46b0436fb000116f36f0a5e813548aae38d66ff4d5824eafb67147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "675b97a83d330d34e1821b0c1d363237d1bdf1201abce2796aadf337cc0918bc"
  end

  depends_on "go" => :build
  depends_on "python@3.13" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.13"
  end

  def install
    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
