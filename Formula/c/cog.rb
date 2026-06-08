class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "69a9046605d3b6912388be5e49ef25bdbf4e328ee89d2866ff34b5528f181e16"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b304cdde1fac0b3bbcd0084041578f7e242d0573ce29220653bed7b434761aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969a072c178d5e4d7b87a4957ba5a2abc8813cccba23aed8286ea6bd6d9325d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbbd93d3486ff14f3a3e9337a8fa900fd16e98642ba9a3a00f4d5393f54d80c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ea2c0b62c84229400ebc5b2b50d9f237be599fa6a84bddf67b450c8e4f58be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0876b1f3959f1e41c47bf51bb8d11ee0f810c4e500168730a4a1b64bbfcb063f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5360f9c78e54772a3fb6a1a10acaebece60d9de1a2917cc2a4dbf1ca7f63c5cd"
  end

  depends_on "go" => :build

  conflicts_with "cocogitto", "cogapp", because: "both install `cog` binaries"

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
