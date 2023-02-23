class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-02-22T18-23-45Z",
      revision: "f678bcf7bac810dedbd0749ae42ddd6d26efdd90"
  version "20230222182345"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "278dabd7c5d9c659835f876000b5b13bbcbf9b7eb8de28774f27dd0c7daef55c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "501fd5b0248a943e7f7b4be336dec2c31e613a057792cf326c43b7fa34051388"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eed921c0425460b5d0d16249efce34823102060a25501db1b100056531ca3d24"
    sha256 cellar: :any_skip_relocation, ventura:        "aeafdd09f0e60275eca134f9c9162988c6308195612840908fa7495aef529509"
    sha256 cellar: :any_skip_relocation, monterey:       "07b193ac8bbaa4bb38d766ad0821f0047d3bc45e19918d1544c3a323536238f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "80150fe884290d5e7c08f12128c5f51f29888c8e37f0f389dac07876fc67c352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87c32ec5d5206207b30258dd2ee7408e141f0d3727bb5617ac1eeae562cee78"
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
