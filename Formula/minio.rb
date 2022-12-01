class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-11-29T23-40-49Z",
      revision: "87cbd4126599ae825903230fdb32197204e42c22"
  version "20221129234049"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3541f0ac07f5644230059801c95084bce7e8b588a79b2a880940d22177b19fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b1cedba7971c886b4a8291607c26165ef65c110d7d2d30a31b21f6884096483"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a9586e78898d6c3c456604368d5221fe4d1ef1d594fc0a93221bae0f7e7fa10"
    sha256 cellar: :any_skip_relocation, ventura:        "3bf21cd66c0c254e76ad4fe12248123d7e06f8fd6af599ba9371eb305f4aa27c"
    sha256 cellar: :any_skip_relocation, monterey:       "f289bd6ec2810ad7bdb1072ebb959b54b2f835895819ec9d0609b3b89ca4deb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "392e9b0b8b6d68c9de63ebadf4c8ea4151ff7c2f57d7475df828d8047493285f"
    sha256 cellar: :any_skip_relocation, catalina:       "b31ada45d5c47969775d0de1995cc7fea646b14945e943eb40bd2740308f0a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d407e7af5c6b759443a51f33a4aa17830c537f38336735f78179cc75a4e45ca3"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--config-dir=#{etc}/minio", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
