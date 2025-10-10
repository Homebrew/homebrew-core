class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.16.8.tar.gz"
  sha256 "a032ffa750f96c1947034249e2bba898c16dc6b474a074dac72ca1124bdf7a9d"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52f469364f8866c4016cd433cb8cf9b11657e2ad6bae2b516452651599502260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f469364f8866c4016cd433cb8cf9b11657e2ad6bae2b516452651599502260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f469364f8866c4016cd433cb8cf9b11657e2ad6bae2b516452651599502260"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1ec610e6e0f6583a81e2027436080a29c813f8e2422023668f672088fc3405e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97e75d6710886a60bf0764d1be05cdec345b6f41f9e90c64effa4923a498a220"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a657e2bc81f01e5e755e76de05f8cc022da603b058a28e94f6569be8b12da51"
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
