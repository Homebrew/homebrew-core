class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-03-15T01-07-19Z",
      revision: "93fb7d62d80161480bac611c09a3fcab6f1196c0"
  version "20240315010719"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "035ac6977aaad48247be4c71b1a3c0503757cd34400917e60a6ecdecb934cccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc59a8ce0d639c4bacff60cab536fd579058f6d5de23766b9e536ea5cfeaab5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f6fc1608dedb9acaf0519041666b449ba93935c455be7933453ff0969648c41"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c8e04e8aa1abd554516825978efec9272cb8e277f425dfe7a2d027b0b968335"
    sha256 cellar: :any_skip_relocation, ventura:        "2e723c7a3120092d99112d0931995f00553e10e9c80a9002b4dfd8ae42f5e191"
    sha256 cellar: :any_skip_relocation, monterey:       "f75eb56b80a366c358407bd8004690ecafec2f3a61387d8b5f980b62f8380d95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc2be4bff4c8813ed6e32161aa541b8f7edc57a39d13d3795eb7b2b9bc77488a"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--certs-dir=#{etc}/minio/certs", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}/minio --version 2>&1")
                   .match(/(?:RELEASE[._-]?)?([\dTZ-]+)/)
                   .to_s
                   .gsub(/[^\d]/, ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
