class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-12-10T23-03-39Z",
      revision: "f2bd026d0e531b35b553b3f2f1045b85189eb8f1"
  version "20211210230339"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "576cbff8fab7c0a9a51874dbe85b9bfc3275b546993e9a4fee2798f938352535"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb528aaf0b71da340f8a178da17a3c6185b2bbb4241646616fd1eea11a0e5ac5"
    sha256 cellar: :any_skip_relocation, monterey:       "2723e1880112aaea99a80a513af8e6f47b374127ca36ae3dac20615284c1817b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae63688f784734e7ec02f74aaf663fc4c47f66a0c004d3579fe640fc03b02a44"
    sha256 cellar: :any_skip_relocation, catalina:       "da501082e962b8e1f77a936ef15e44c1b74bad108c5eb0912cf5d32725b08d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77d25466ed3341558aabfa3d7c0d36ac15dd9f25ccf255a442800b53bac30e3d"
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
