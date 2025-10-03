class DockerDebug < Formula
  desc "Use new container attach on already container go on debug"
  homepage "https://github.com/zeromake/docker-debug"
  url "https://github.com/zeromake/docker-debug/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "f872f649db05f3670650dd7aa3507b0658eb29557d0d2685658ab581b2919101"
  license "MIT"
  head "https://github.com/zeromake/docker-debug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afbd63cd10a73b068298aacc91fdfb51e91dee353432f710abe981017804c1af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afbd63cd10a73b068298aacc91fdfb51e91dee353432f710abe981017804c1af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afbd63cd10a73b068298aacc91fdfb51e91dee353432f710abe981017804c1af"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f06227dd443be8e30c2c64d16c91fd47ab053fbab87ad0c44eb9637fe84d1e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4339ab5462b42fc79c1504e6e55b8773a40facbfb0619d4d88ef562f37dc4ba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd5b63ab3c20097b3b4cffe0f6e9b5f163f13dad10da58c26b02516fcf68b46e"
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

    generate_completions_from_executable(bin/"docker-debug", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-debug info")

    system bin/"docker-debug", "init"
    assert_match 'mount_dir = "/mnt/container"', (testpath/".docker-debug/config.toml").read

    assert_match '"TLS": false', shell_output("#{bin}/docker-debug config")
  end
end
