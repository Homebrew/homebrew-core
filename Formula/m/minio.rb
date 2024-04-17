class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-04-06T05-26-02Z",
      revision: "9d63bb1b418f6c1bbcc8434fff5d8aba810ee5d7"
  version "20240406052602"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88f1043190edb494e11b6f2087d7822618e2615920130e1f7c684f7ae16329da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70b1eae7ee6d41651353decb8f3bb23386a879c552003d47da7cdaf923eab8ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a9bbb49bd0ff88ed9d2b5f8a2869e20ba9aba3f796c757503fb9aa9ef4adee0"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a68dca438b5864ae1e02b7e320e5e5ab2544effd7d9d3fa149108ae9f1b40b6"
    sha256 cellar: :any_skip_relocation, ventura:        "99d23f660f528a9e74b30c512b63a0c6f440c7606982500108e89496c4e6b388"
    sha256 cellar: :any_skip_relocation, monterey:       "f1121a795d39b2cce74c1e898117042c893b154312ed7649bf242f58c6d91117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f8ed819405e0cb0cf7e5d26889c646dd09c6bdd171a56300275d931480e0e75"
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
