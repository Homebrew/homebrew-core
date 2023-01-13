class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-01-12T02-06-16Z",
      revision: "7bc95c47a322971aff7d4d4c270dcf28a933e84b"
  version "20230112020616"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da7948b75a3562853b81f01ee3b7b65d88d3482be415bc81983a33ab076832a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e96ee654b12a7a9b4f9ba8a4b7fe9d933e5de5bea4b8a76561610bf07e9ff7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77d84f0eaf5d03b6fc2498d918aa368b86fe749c70a22b3dc78b73fc79a7e500"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ac22bbaa6b46bbc4272ae10195dfc2c298d560b6c7125c91b669d61aeb3a73"
    sha256 cellar: :any_skip_relocation, monterey:       "79a3544df889069d2a531626c6be8cfa96579f59cd7a65fb262dd391ebe4d544"
    sha256 cellar: :any_skip_relocation, big_sur:        "78aa95fb4abf17ab9b75a78ba9980307fdb8044c5ea4e23144113f78c747df94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d2f29947c6cf0618b51a324b151b405ac1f781c60f284e91b2bea9cd93c45bc"
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
