class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "fcf38cb76077658aebbf33462a3e6175463e0a29680b6b7528820be86df44209"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88ae69327d2e221f8ed701545330a162b02ef8de31c887bbcccfa9441e078b13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88ae69327d2e221f8ed701545330a162b02ef8de31c887bbcccfa9441e078b13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88ae69327d2e221f8ed701545330a162b02ef8de31c887bbcccfa9441e078b13"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a4bdf64fb799dd99e0ef84f2bf934ffa5448ea58a64ec91be960559cf3a131b"
    sha256 cellar: :any_skip_relocation, ventura:       "4a4bdf64fb799dd99e0ef84f2bf934ffa5448ea58a64ec91be960559cf3a131b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c90bfaa8de7e3497719ae9f98e41f55da63fd9eabcd27008521ccfe9f450eddc"
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
