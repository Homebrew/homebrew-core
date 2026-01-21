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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34367cbb25c32d9dd785b1030795fcbcbf42ae90584a1d97eefe698b59a8f5b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34367cbb25c32d9dd785b1030795fcbcbf42ae90584a1d97eefe698b59a8f5b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34367cbb25c32d9dd785b1030795fcbcbf42ae90584a1d97eefe698b59a8f5b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "526edc6ad0f52e67bc969cb036ae04fa8d98ad697c39887034214d68e9bfe9bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15a3792f5d0603c650629099d5bd6e86bfedb23fa92c15584873e9b97495a604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db4c05261fec1d94f1e59fd5c68bd275c51db0a4349bf941c1c63a0763c0ff72"
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

    generate_completions_from_executable(bin/"cog", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end
