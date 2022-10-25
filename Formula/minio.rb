class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-10-24T18-35-07Z",
      revision: "fc6c7949727ec261cd57fbdb02fa7575d0fd8e61"
  version "20221024183507"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f8261932bfe8c7fe240074f1302820f378d1b064b8f0fc01bcc18923150db95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ce61da49b37d5037ab62abe1a76ab98deb7e72c9abb4fa2718521a0343b29dd"
    sha256 cellar: :any_skip_relocation, monterey:       "d8263285851bc0be4441de03cfe1a88c5171146118f308407d97dcc51ee1ceb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1a5036a11b81132a71b44f13475429415697e13a84adc5e4ba3e606d7a331d4"
    sha256 cellar: :any_skip_relocation, catalina:       "faaf6c55e055ac82d47fd31449fe0b24f74a132bdba37f4a8921bd242b8e6b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74f5127d1bcbddb9526fa80a21ddff4713b5df483892e97f7c270781f4e25e29"
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
