class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.9.19.tar.gz"
  sha256 "1e58bff4c1152048bab81451a38a69a04bb697749cef6d9bdb02462950aca919"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4fbc4f40729d9a29d7f85a2e8a0f7f18819c48e565d4f6605812768c173eaf8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4fbc4f40729d9a29d7f85a2e8a0f7f18819c48e565d4f6605812768c173eaf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4fbc4f40729d9a29d7f85a2e8a0f7f18819c48e565d4f6605812768c173eaf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "14c41046ae5258f595c13f2f8ecfabb8d12470ef93bd48de39f5f45a49bf3a9a"
    sha256 cellar: :any_skip_relocation, ventura:        "14c41046ae5258f595c13f2f8ecfabb8d12470ef93bd48de39f5f45a49bf3a9a"
    sha256 cellar: :any_skip_relocation, monterey:       "14c41046ae5258f595c13f2f8ecfabb8d12470ef93bd48de39f5f45a49bf3a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46a4ef82656bf4f8e3140f3d11930103fa49e216864a2c37bce3f04c5ebe8c96"
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
