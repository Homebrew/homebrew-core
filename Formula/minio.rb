class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-02-16T00-35-27Z",
      revision: "21a0f857d3ed71de05d6bb9a07ce2f6e24a93a2e"
  version "20220216003527"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "079c64fb0bcc62fcb021c06b08435ff19bd6f6e8ed2ba52032832826e074631f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e3183c01c76981acf72feda615e4a94588075ffd9c1b565c4b8b7e0c0d296e4"
    sha256 cellar: :any_skip_relocation, monterey:       "5903935c16b7cf967806fc44812fad29b8f86f18c87dad34b8fcbfc26d80e013"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ce9e92729126bfdd0c23c9182119271065c0e5079bf4639b6109dccf841092e"
    sha256 cellar: :any_skip_relocation, catalina:       "f4be202f571a7e889607ef9f712541598cdc6c0ac7ae6dab28d5b9998183616b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcc7c7cb3c6ed57e19c96285d96dcbb10a3651ce4ce04edc3a341ab47b74976c"
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
