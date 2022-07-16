class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-07-15T03-44-22Z",
      revision: "1b339ea062b423f1c6fbeb02116d020d18418917"
  version "20220715034422"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e511cb74837e47ed8a8cf0f899673d3daec72c0e0a5de87ddfbc229128ac6eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad817f3a05ab8546504e9c2f6d332f1be2d475e8323ea5bbac33a20050c02c74"
    sha256 cellar: :any_skip_relocation, monterey:       "79424a7ed19e6092268177845ddc47fa3919962dc618d26f6d7d278a332c775a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9b4734362b508f4729301a9939400e0a52b1eb97ee17dc85c0898490b3fca45"
    sha256 cellar: :any_skip_relocation, catalina:       "bfeea3b0d2e21d5400efe91f02870e3d6b9d860169f4fef285a7d42f88d0b5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6a100992470423da2d09564de561aafe80dd0ad55a602c4b59144075476ce3b"
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

    assert_match "minio gateway - start object storage gateway",
      shell_output("#{bin}/minio gateway 2>&1")
    assert_match "ERROR Unable to validate credentials",
      shell_output("#{bin}/minio gateway s3 2>&1", 1)
  end
end
