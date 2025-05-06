class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.14.8.tar.gz"
  sha256 "1e5de299426f59dd0f42a135400e252601dcbad25c110d5e13b577733c86dd7a"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfdcf817f86e87b74a381307a92e79525264475e7f5d5e15265058b003fe73c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfdcf817f86e87b74a381307a92e79525264475e7f5d5e15265058b003fe73c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfdcf817f86e87b74a381307a92e79525264475e7f5d5e15265058b003fe73c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d94e651e9b52ee26da32a3995cac0207d2606024c8b94114c327813516064b25"
    sha256 cellar: :any_skip_relocation, ventura:       "d94e651e9b52ee26da32a3995cac0207d2606024c8b94114c327813516064b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e854e4cde708f400aa415c4cdd1b9377bf40b5a24839396be371a261d9a66994"
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
