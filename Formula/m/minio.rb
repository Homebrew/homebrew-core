class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-05-07T06-41-25Z",
      revision: "b413ff9fdbecab75e9a4ee40f5f8390f37ad752c"
  version "20240507064125"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29bfab27791041464fe9f3cbf5ac2c99cf1ae2caba83c9270b2f12c83da084aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ff3463dbe2a46155b3804209115453349fd9a02be0af61704fff5d4256b7ad0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e16267a8eb3369eb4bb1997b1fa294cd5eca4c5f2fda559879cd13827e191198"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa52a7a57d2402700d82e6e0de04b51fc0fa42a14d8a5c489121ee086911fec1"
    sha256 cellar: :any_skip_relocation, ventura:        "c112958c6fa3c86bc609011b58b9cf9e7870d3ed2e329a03e179a3554ecd7399"
    sha256 cellar: :any_skip_relocation, monterey:       "c0733ecf090e2418c1c33a1c0633d4e5a041d277feb7b660288fecd1d6deebe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83b2595f24f77c9c8a10c4fa1f4a3492e220d718c54955324e73d8ab910ed62"
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
