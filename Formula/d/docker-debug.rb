class DockerDebug < Formula
  desc "Use new container attach on already container go on debug"
  homepage "https://github.com/zeromake/docker-debug"
  url "https://github.com/zeromake/docker-debug/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "5b7682acc6dcf93d9d260de88c269657348c4ef6db1ef184d794786509ba0af3"
  license "MIT"
  head "https://github.com/zeromake/docker-debug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "972fa49c80948a98642168ce1cb3529efaf162a11df1899dff8fdbc9cfb5dfd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dfe42bbe836be8f2fd1345be00fb14810fa823ab353d9aababafdf0ba51737b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dfe42bbe836be8f2fd1345be00fb14810fa823ab353d9aababafdf0ba51737b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dfe42bbe836be8f2fd1345be00fb14810fa823ab353d9aababafdf0ba51737b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c6629ef906f47228d1942689538b8d4eb8703f0f19bab4b172d6ec86a431f21"
    sha256 cellar: :any_skip_relocation, ventura:       "1c6629ef906f47228d1942689538b8d4eb8703f0f19bab4b172d6ec86a431f21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae4243281887a3e42b54cc89edc0d9d67ecbc4c41140ea9b3db4f9617d8f598c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36b8ffa5f59cbcc3a3b82ff0bc51060accad5a55c8f5a59197f561b89fce2621"
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
