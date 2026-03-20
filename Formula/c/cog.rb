class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.16.12.tar.gz"
  sha256 "9398654a7443e752c0834a1f9f76519298445f77c499dc33cb052c7c7c8aeb00"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ec952d3dcec7e2ff45b46af19f017f4114ab165cab55fd4c013ee88bcd7d496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ec952d3dcec7e2ff45b46af19f017f4114ab165cab55fd4c013ee88bcd7d496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ec952d3dcec7e2ff45b46af19f017f4114ab165cab55fd4c013ee88bcd7d496"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbafa5af636d662a73fe6f87960944264f42c68e3bd6ee4f1a8310e1a1f2f202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfa1d0f9379ffc4888a87c150f2170e25d36761a78c26fdd5fc6e2472f0abbe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d83148977a405446aa05a21d747ea91819d781e550d6870bb4e19c3a20710409"
  end

  depends_on "go" => :build
  depends_on "python@3.14" => :build

  conflicts_with "cocogitto", "cogapp", because: "both install `cog` binaries"

  def python3
    "python3.14"
  end

  def install
    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_COG_DATACLASS"] = version
    system python3, "-m", "pip", "wheel", "--verbose",
                                          "--no-deps",
                                          "--no-binary=:all:",
                                          "--wheel-dir=#{buildpath}/pkg/wheels",
                                          ".",
                                          "./cog-dataclass"

    ldflags = %W[
      -s -w
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
