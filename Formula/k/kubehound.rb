class Kubehound < Formula
  desc "Tool for building Kubernetes attack paths"
  homepage "https://kubehound.io"
  url "https://github.com/DataDog/KubeHound/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "debb8401622363a30a5e130da3b4b08f7f857bc2ecfe0d2a179ffe09ddc6a2aa"
  license "Apache-2.0"
  head "https://github.com/DataDog/KubeHound.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d7852a73d2cbb650112cfa6b0815cf08e28a6c70f9b5917fbca7eed7d446068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0edb68186363bee23d020676c1a72771bbeb5aa677ad92a4d03250c9e58852b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8888b129fcc1ee3124650623dcea8aa3f10847da06ec932cd370a8604e617e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bda2172d58e2a77075289b5c1842a464532a48fe80d0297adc0c482be261e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "938ac1e9a811d346e783de5611f336e9de3251a411b6bafe9a49c44929c4984c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "769eade350344b79607a86d55d780a148f22dae16acdcee40056a1f55c4d1654"
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
