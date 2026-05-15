class DockerDebug < Formula
  desc "Use new container attach on already container go on debug"
  homepage "https://github.com/zeromake/docker-debug"
  url "https://github.com/zeromake/docker-debug/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "f872f649db05f3670650dd7aa3507b0658eb29557d0d2685658ab581b2919101"
  license "MIT"
  head "https://github.com/zeromake/docker-debug.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0faba1df5f1cadcedabd4487f30a0db88072ee50cd92d095f7366b410fb6c42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0faba1df5f1cadcedabd4487f30a0db88072ee50cd92d095f7366b410fb6c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0faba1df5f1cadcedabd4487f30a0db88072ee50cd92d095f7366b410fb6c42"
    sha256 cellar: :any_skip_relocation, sonoma:        "978911584a039d17fbc927934d0d9c9eb3477eba58b6ea1df5a461a6f3d4e92b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec74e9da2a07744c7608e482b1573a9178746022cc19ddac7b4c0e7a1f7fc82a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cacde51f354d073566e5f6452a545a0df24ae0ace59d8c2a60adb4954519cdf4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/zeromake/docker-debug/version.Version=#{version}
      -X github.com/zeromake/docker-debug/version.GitCommit=#{tap.user}
      -X github.com/zeromake/docker-debug/version.BuildTime=#{time.iso8601}
      -X github.com/zeromake/docker-debug/version.PlatformName=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/docker-debug"

    generate_completions_from_executable(bin/"docker-debug", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-debug info")

    system bin/"docker-debug", "init"
    assert_match 'mount_dir = "/mnt/container"', (testpath/".docker-debug/config.toml").read

    assert_match '"TLS": false', shell_output("#{bin}/docker-debug config")
  end
end
