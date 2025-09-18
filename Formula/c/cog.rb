class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.16.7.tar.gz"
  sha256 "9468e9917b4faec5a1c323b8d79a0cf78a48af97567ebe7602f44d1e1024ed28"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b942a7bda912bca50448ad19ee83ec8442b991b8007f4d52e033199ac3ee01a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b942a7bda912bca50448ad19ee83ec8442b991b8007f4d52e033199ac3ee01a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b942a7bda912bca50448ad19ee83ec8442b991b8007f4d52e033199ac3ee01a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b942a7bda912bca50448ad19ee83ec8442b991b8007f4d52e033199ac3ee01a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f0772d1cc0284500fd67614235a981831d695f1736c62d7101e1c9a344d8981"
    sha256 cellar: :any_skip_relocation, ventura:       "9f0772d1cc0284500fd67614235a981831d695f1736c62d7101e1c9a344d8981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d311fc3a66f5fc35b81c033c64958f1739ef61c6175a755164ec853e247db20"
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
