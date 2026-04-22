class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2733dfa0de13b53463ebc13aa4cf1783c9d9e3e3c3fb6ab4f435accb4b39a13f"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9a59f0e636fe320078558678edba2ce7c4e8424e263b2dad7e8740373a78917"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ce61870d7a012f3bd17fdaa4f5f3568fdcdd958414be5fbe44e4a962a9b8ce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5004168757e332ad0e81cdd138e70e484610e476f03d0d5fc0a3ead9fc1cf09f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b0a0987e56475d6b67f42c4c3ff482dae08ac8cba786f1d6f2ebd5ef6ffb0a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7bf94cd4bf910a95fe297e5f3829c50dbb95f9a58ba5c20ecce714160d21b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65cbf3a8aba2f6209e3747f23dc209ef7eb252bc9e00bab6ee8bd1c21253d679"
  end

  depends_on "go" => :build
  depends_on "python@3.14" => :build

  conflicts_with "cocogitto", "cogapp", because: "both install `cog` binaries"

  def python3
    "python3.14"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

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
