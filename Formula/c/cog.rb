class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "4afd658c6bb5e74eabe307080d07699a2580c590d29c20d3313e281da334d47c"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2702c7af05f500a40f57a7a2055559eed6745fa3926347d2ecb69d5a99aac239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2702c7af05f500a40f57a7a2055559eed6745fa3926347d2ecb69d5a99aac239"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2702c7af05f500a40f57a7a2055559eed6745fa3926347d2ecb69d5a99aac239"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaddfd83af47bfab910dc469bece9d7e2e97f64545d7431d2e6f0c65612320ee"
    sha256 cellar: :any_skip_relocation, ventura:       "aaddfd83af47bfab910dc469bece9d7e2e97f64545d7431d2e6f0c65612320ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1945e92bb4c90d6ddc85766c38f63cac6f39ff1ba70b1d3c3a1d7198ccfaffbb"
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
