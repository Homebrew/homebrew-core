class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-09-07T02-05-02Z",
      revision: "703ed46d79bba51d5d781e2297ca0216c99c8536"
  version "20230907020502"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bdfcc5fcc2373a102996cf882e4368531c1126e992d6c04058c2c6afe49b369"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bc96c1b15d100dc1aed783d09199671349e63a3e62f85b44c0aad36f85c731c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d1cd54fd139332c746212ab32252fbe94d1c9c4331f221ee272d34e69704cf3"
    sha256 cellar: :any_skip_relocation, ventura:        "15e809fa55f34c5261667299c4114108c433fee709bf3675aba2f552e926317f"
    sha256 cellar: :any_skip_relocation, monterey:       "03719300fbf1819744cf28752dc2a544a8479ce4ce7490b8e596c2ebf8267f0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "53ffbee1053fd0dd13c1473f58d0d0882ced87a8d7d8cb9eb58bedb125f6260c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6abe246c63a25eba780ff5906fc90fa4e093a9f4d3eb2f39fee51546aeb2356"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
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
