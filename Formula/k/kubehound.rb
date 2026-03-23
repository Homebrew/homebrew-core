class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https://kubehound.io"
  url "https://github.com/DataDog/KubeHound/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "b753e20ef6200e1bb0e26e0afba9bf9e76f5ea7a2d823bf90dc88b60f4ebd31d"
  license "Apache-2.0"
  head "https://github.com/DataDog/KubeHound.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ed0e5bcc02c1fe5fd9097597ec362a713a01d8dba8aed76a1dc35dca5423458"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22a99818f4c97fa26941886c33aafdacfb5c90ba0d6891d3004a0917dcf27ea8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c3f643db8156e52a8918569bd9e7a4b6ff46f471dacfe350fd1653160d4ffb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "79367aaf47312361c2e27be4467c9038e71a51eb1143dcb9ab22b34b7f6b7c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "714f67c61f7051582d98cbcb3ad49b36df56f2cef8c60f5aad12806b166877a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7ae490424140e2fbd8d5d6ec33763774e4a566571cc70d77c2d10149e34d980"
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

    generate_completions_from_executable(bin/"kubehound", shell_parameter_format: :cobra)
  end

  test do
    assert_match "kubehound version: v#{version}", shell_output("#{bin}/kubehound version")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    error_message = "error starting the kubehound stack"
    assert_match error_message, shell_output("#{bin}/kubehound backend up 2>&1", 1)
  end
end
