class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-09-22T18-57-27Z",
      revision: "20c89ebbb30f44bbd0eba4e462846a89ab3a56fa"
  version "20220922185727"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "464f57c112123970150f886b5232069cf7c80bdba877056cd67673587d1ee385"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "552c7fe025dc8553c7d3099af34547d53e8ff38d9cab95e35e0636568c90d958"
    sha256 cellar: :any_skip_relocation, monterey:       "96f94269074c25c8d80bc9a512bf25c5c9ea0e800059f8eb2871b24114d3aa29"
    sha256 cellar: :any_skip_relocation, big_sur:        "c58cdace9acfd8293b11de23231743e0c7c8bc54c983db33d0528170cc331f04"
    sha256 cellar: :any_skip_relocation, catalina:       "66a5b944786dd391b93c9b7b0851a1c87c1308032499112e21048f78607ef464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05a3f4049e9b0c1bfc77120342ca4a9749710f8d6db81f5ff1bbc655b79a5eea"
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
