class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "46114cac917bca72b6afb8b25c6cf70d2fddd5751bde2df9a29f27082381aaef"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52de999a433471de0a3a9b5e4d1b83abbb1aa62c5d67b3d9c543baf671334dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52de999a433471de0a3a9b5e4d1b83abbb1aa62c5d67b3d9c543baf671334dca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52de999a433471de0a3a9b5e4d1b83abbb1aa62c5d67b3d9c543baf671334dca"
    sha256 cellar: :any_skip_relocation, sonoma:        "e028496a9708365607cbc144f1af0862d25aca4b2e577a80f44140f33470738c"
    sha256 cellar: :any_skip_relocation, ventura:       "e028496a9708365607cbc144f1af0862d25aca4b2e577a80f44140f33470738c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "551f19e47ce3706dc72fe81fbff9fc18d25a6cd2ebaf6ba21d875e209d8fbb7a"
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
