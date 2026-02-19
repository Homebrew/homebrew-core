class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.16.11.tar.gz"
  sha256 "b1d1dfe7be5450c1f771364a11068d76ea9b47f090fc014a77ae7ee00268d22f"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa10ddd786839aea1e931337cea75368239afea67e097f0dba9fdb94eee54b3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa10ddd786839aea1e931337cea75368239afea67e097f0dba9fdb94eee54b3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa10ddd786839aea1e931337cea75368239afea67e097f0dba9fdb94eee54b3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "99d36acd8d03da94cb44930f3f464a6b53bbe3e7b41c7b8591721866ed2aa4b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0de20006a4709fc932f9089b93b9035490e7a17c1eb08db4f8c8fa231d2a552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adc46632f2967ec70b7226a3826d61f7487a4c583fed01fe725245a32fd2b1bf"
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
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_COG_DATACLASS"] = version
    system python3, "-m", "pip", "wheel", "--verbose",
                                          "--no-deps",
                                          "--no-binary=:all:",
                                          "--wheel-dir=#{buildpath}/pkg/wheels",
                                          ".",
                                          "./cog-dataclass"

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
