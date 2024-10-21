class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-10-13T13-34-11Z",
      revision: "d10bb7e1b667c2df72c394ef1fa52ab4a6802d0f"
  version "20241013133411"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "156f5c2b417f1ef30e7b8afe737dfaa3a6de867d10a963273d9be9fcc93cbf2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b29a9b5fb6b3b96f7d4c7d25914b81ddead22d146a0b949b9baad241cd87ee1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "154d3f04a2b714d1c9a7d2c1654f1411d1b7ff0dc857fd657bcc4297caa8b356"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd0b40a7daafa146b6610b4320bf1caa29e6a1a3f5ceb2297f78b2b38cdfe6f"
    sha256 cellar: :any_skip_relocation, ventura:       "9ae3c3296c8955e1e794c39eaade176f91361ab5a55cc29817af343a44f4960a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faff9f982cb81399b4129cc6da535a57370c5a2751f951a82567643c60944039"
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
