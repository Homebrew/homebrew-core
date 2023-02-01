class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-01-31T02-24-19Z",
      revision: "2d0f30f062e9ec3da8887e5ee64f59f5cea03240"
  version "20230131022419"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dbc914688c7f8cdd572271ab70652d3f03c5e3d8b20dd5062305205da2b1db1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9722d5e8fdcb8da9e6077b4c674f4ff612457c69c47319233989971fd4328c63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fa3b433326643733695cf45e77c8ea97f590c22b2ce19ce6aab8053d0c389a5"
    sha256 cellar: :any_skip_relocation, ventura:        "76d8d69a09802f811235641a7b7ce27cade2bc2a4e4e0da1b56af8ce4012e609"
    sha256 cellar: :any_skip_relocation, monterey:       "0b81681c94c995145c5ec3d1dec3709cc4e2ab826ee69a54ff8a3627d1eb26c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "be36753ebab1b8e52cb7a2474c3afacdfef2527adaee1c9f8b9479b7d78c1c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecd708057157862dc52d387db2babf4fd7684350af7079536dbf6555cb73f7fa"
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
