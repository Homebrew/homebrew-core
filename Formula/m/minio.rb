class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-08-16T20-17-30Z",
      revision: "d09351bb10883d1b55579d11ad68efafaa86b700"
  version "20230816201730"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d83b0996d0f5685f5c45cd3afe31ce011ff5c12d1ee2a2c20389f902bded9f0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c519a4cadbf35611c76d8889ded9064caa43767e94750eced965e7042d43bb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e4d8c1b573967d1c7783bb3b44dbff834dd0b71f36fabe205554a531120c413"
    sha256 cellar: :any_skip_relocation, ventura:        "d813b644e4a2416f9799c3c36dd5f29acf2b34ee7d28059974f4eb68d872ad2b"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a39f0f082fd0d1db54006cad90588649236cb482beee3e831f8cfdbb2a4290"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a56d102a40e6c1a2c4d27f74cc20300d01c064098c0bede9fc3f8664591da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cc1a28a12dd5d57823e662ed510a2fb0e46430ebf89d5e7dc48ca68e4c7cfe9"
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
  end
end
