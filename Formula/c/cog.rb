class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.25.tar.gz"
  sha256 "6b45f5f3c4e9524e62f7421c5124e247209e409b235f6633bc7d1a318357fc6f"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8d3d4bfd28962ca035a05bb1f4cd70a27ee5515ac6e330d85b4dda5715d64ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8d3d4bfd28962ca035a05bb1f4cd70a27ee5515ac6e330d85b4dda5715d64ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8d3d4bfd28962ca035a05bb1f4cd70a27ee5515ac6e330d85b4dda5715d64ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "7de6268a5262b57bce31da59efc95cfacb2ef0fb8ab0038dfed54fa8ab2e9ce8"
    sha256 cellar: :any_skip_relocation, ventura:       "7de6268a5262b57bce31da59efc95cfacb2ef0fb8ab0038dfed54fa8ab2e9ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0de62f5d5620ed27a65806a38c5a7092989002595bc79632f62ca442cd082b7"
  end

  depends_on "go" => :build
  depends_on "python@3.12" => :build

  conflicts_with "cocogitto", because: "both install `cog` binaries"

  def install
    python3 = "python3.12"

    # Prevent Makefile from running `pip install build` by manually creating wheel.
    # Otherwise it can end up installing binary wheels.
    system python3, "-m", "pip", "wheel", "--verbose", "--no-deps", "--no-binary=:all:", "."
    (buildpath/"pkg/dockerfile/embed").install buildpath.glob("cog-*.whl").first => "cog.whl"

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
