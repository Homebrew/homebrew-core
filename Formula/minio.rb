class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-07-06T20-29-49Z",
      revision: "8d98282afd1f2e6fd3bafad70a0f63b059fd91ed"
  version "20220706202949"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d4d423631356e4ac2e66ccc0dd911244d3b8a0eacdb13b0bea4214039132453"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e0386176c350dea697c6b754917b26e9d26bcd960ec9e5cac982d12ef9ff482"
    sha256 cellar: :any_skip_relocation, monterey:       "8c652451a20aaf87403c82f2a643bbfc4294dc02246b9cc9516770044eeffc9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e532055a6a9e788c9705c91877971307f4c3bf72fbf18f81b778356a91f4c76"
    sha256 cellar: :any_skip_relocation, catalina:       "c4d4e8944b205e1f3b8b5c3e5fbeb81d2f4eb6b5d8ee15aaad0da8e9942769ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f2a06e53c67b2b43092d213db2ea9dacbed3fbb633ad7e6359f8a9f9e90ed5"
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
