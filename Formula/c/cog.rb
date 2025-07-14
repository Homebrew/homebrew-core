class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.15.10.tar.gz"
  sha256 "5876d0d5011131c396bc557d04b7e531b57be99350fb530c88bf7161c430e773"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c4feb669e561a292accc31914301ad817a43feef63f724cf9a6f7ed5b8ecf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97c4feb669e561a292accc31914301ad817a43feef63f724cf9a6f7ed5b8ecf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "97c4feb669e561a292accc31914301ad817a43feef63f724cf9a6f7ed5b8ecf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9c28e3bddb3ce66c3a7e604b13ae183f4529f2f2f0a18e981a0fecf47e02784"
    sha256 cellar: :any_skip_relocation, ventura:       "b9c28e3bddb3ce66c3a7e604b13ae183f4529f2f2f0a18e981a0fecf47e02784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dff4e1621c2546e890b24a52d7575020968e057c0b1fa2f41aa0f012542ace81"
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
