class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.15.6.tar.gz"
  sha256 "ceab500ceb76ac44843eab922bf5f0eb06d33f0f5122d747206aada55f4c3c5e"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61c0adb7f4ff2d31666e6e929a3f5277faf9eb094288c523d5fc874294a449d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61c0adb7f4ff2d31666e6e929a3f5277faf9eb094288c523d5fc874294a449d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61c0adb7f4ff2d31666e6e929a3f5277faf9eb094288c523d5fc874294a449d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "083a99db1bca8ee99a439261330e2791c9bceb365d49a9a77d41770524987a8a"
    sha256 cellar: :any_skip_relocation, ventura:       "083a99db1bca8ee99a439261330e2791c9bceb365d49a9a77d41770524987a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b3786a0505d46b3223a515a359e581840397128dc0994b3997784679af18cb"
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
