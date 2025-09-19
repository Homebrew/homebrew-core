class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https://kubehound.io"
  url "https://github.com/DataDog/KubeHound/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "a92b3a9e07f71d3462815e5b6d706a56aa1e7b6e99dd59926dfb31bea15fe73a"
  license "Apache-2.0"
  head "https://github.com/DataDog/KubeHound.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4389f31009dc324be19315c53d635b9f8ac354559a8089189c37d47ca4a59ebd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f5f80ac7b37055119254d8b1c021b73f79a90e3144564996de8d70b6a589a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f26b1cce56e82aa0692ff583ba0cfae00ed1f89beafdbdd220b726fa84f9bbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b10d7b58c11853112ddfb8b02d7f9a2d98d47b807cdc9174f223a81ebeafd7d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0ca2e9b024218f6e8b8c8b378cd6f73fea92ca0804c7f517d6df02cf9aa441c"
  end

  depends_on "go" => [:build, :test]

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X github.com/DataDog/KubeHound/pkg/config.BuildVersion=v#{version}
      -X github.com/DataDog/KubeHound/pkg/config.BuildBranch=main
      -X github.com/DataDog/KubeHound/pkg/config.BuildOs=#{goos}
      -X github.com/DataDog/KubeHound/pkg/config.BuildArch=#{goarch}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "no_backend"), "./cmd/kubehound/"

    generate_completions_from_executable(bin/"kubehound", "completion")
  end

  test do
    assert_match "kubehound version: v#{version}", shell_output("#{bin}/kubehound version")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    error_message = "error starting the kubehound stack"
    assert_match error_message, shell_output("#{bin}/kubehound backend up 2>&1", 1)
  end
end
