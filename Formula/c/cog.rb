class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "2c3a91742af9301412e71e77c6be5967be5e760d2fb378af92e0a02605f75457"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7358b917dc6de02228cd3a12aa82db780ea5491ebab840d2b6b908c323d5a10b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7358b917dc6de02228cd3a12aa82db780ea5491ebab840d2b6b908c323d5a10b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7358b917dc6de02228cd3a12aa82db780ea5491ebab840d2b6b908c323d5a10b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d207b9e35e30f51827b3291c080c9285cf754c58cf015464338356a0f3af7bed"
    sha256 cellar: :any_skip_relocation, ventura:       "d207b9e35e30f51827b3291c080c9285cf754c58cf015464338356a0f3af7bed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6368bcc20150094d15de3da752538f130cf4bf2659311d514ffd4d35bc2d224"
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
