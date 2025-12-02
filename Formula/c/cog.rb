class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.16.9.tar.gz"
  sha256 "13e6788e155db078f1f67948741ce26d8144f8c0861d8fc418e7bd8b43697dff"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ceb44c693ad1be55ce40fbae109e0783608537193fc54edcb1ec74ac76f3590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ceb44c693ad1be55ce40fbae109e0783608537193fc54edcb1ec74ac76f3590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ceb44c693ad1be55ce40fbae109e0783608537193fc54edcb1ec74ac76f3590"
    sha256 cellar: :any_skip_relocation, sonoma:        "f64c417716866dc2639b9924fa4c312781206d2ff45a90b29d08218db93f0a0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcee96878607aacfbf2d9e60768bdce322acec77aed6d4a94fa3bdfb21bc8162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08d62fc0173dcd91ef42030dea173323d3497fc78b407c84f50deadb25779c3f"
  end

  depends_on "go" => :build
  depends_on "python@3.14" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def python3
    "python3.14"
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
