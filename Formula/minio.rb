class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-01-08T03-11-54Z",
      revision: "b7c5e45fff935994791f89237a4891185c55b91f"
  version "20220108031154"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ba35b4f55e947c9bab7f5978981e11cf3717d2eadea62f14a98cde3cb07a848"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "852dc5ef16ce708a687dbd2fbb568100770f15e8c7247def70b3a9a8e82bd390"
    sha256 cellar: :any_skip_relocation, monterey:       "d05711892421cff8ff78cbdf80181b5d882441aa751dc845455433fa059d3b97"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6d0f657c73a027cc8ed6d67f613be3cc967a7341d184399e4ad7f90756a62b8"
    sha256 cellar: :any_skip_relocation, catalina:       "e8dea89694fd2799c96fad8278a80a66d00a25468bb0b6946a001a4daddb2ff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aa99847b316fe9e0d594ffe95f7c02760a4f85962c5aefd7c8f25b593e7dec0"
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
