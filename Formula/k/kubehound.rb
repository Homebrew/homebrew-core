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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b21c06a276e833fc59793789abc140fedf34f87c929e11c4266573d547e95688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d57b9946f4af692fbe0f724ca3097536ee7a04cf6e0eada398368ef1041b202c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c7968bf9a46e7a70e3017eef5f5420e952f471ef7717d953af9c6f64df541ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ea422b124724219a266999a7336d1b3e53cf9346ab4c720b0cb5a76d810d062"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc41bf622694ab862c26556620cbd4a82aad40db7cdd3dffee17e203a9caa451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "342077b06c7865acd7822c1a298deada1058ae7fbebc9f269f5f875269bd4548"
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
