class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://github.com/replicate/cog/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "1fff8e5d7c62ae14fcbc3e7fea9262e301a6adabd4c75e0f7fa28490e09db78e"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ee52c65d1f6f71bbc0b4e4c94e5cd5749980e70e8473f0b627b162f2f396fba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b1b1a33d3e13aadeae0e92ada04fe2d94aaf1a9e1c68c20559d93c3e01e74c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9f8a8ae4dd426fe7db53cc907e068bd22161b9ea6d319583d31ab7ab5e72592"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfeb6c46b8da833d49d5056f8d312465ff0b0fefeff8d9915c93b8d4d51957c1"
    sha256 cellar: :any,                 arm64_linux:   "c6d733304e92cff429befff4a242ee1ac5e3d448a29ecb762cf6c55ee7c7376a"
    sha256 cellar: :any,                 x86_64_linux:  "d218e4224914a82dbdf05ddb2909aef481185d8f552f7c8320baf509d49064dc"
  end

  depends_on "go" => :build

  conflicts_with "cocogitto", "cogapp", because: "both install `cog` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
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
