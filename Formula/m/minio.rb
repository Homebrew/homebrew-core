class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-12-14T18-51-57Z",
      revision: "6c89a81af43316fe6c82420034b8a048631a1f70"
  version "20231214185157"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f3358193bb8be035ec8fd751b09980c6dd04fde888567d14b5bee6b7f231ccd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b41665e18dbd6786e0f2fa65ebf50b47b9501017d84dfd6f20dabaf9dd3acb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "859b6e5fb288750464d7213204aa12e797b2b290ee7ec3c83b9ff37cd8f0dab1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b4636f12b3f9a7aa6b55cde1a3aa96405d7e57b37b56482699a251c13c3c764"
    sha256 cellar: :any_skip_relocation, ventura:        "2430bb281a43dc773966d2b6c4e4a5d747f0bd5c5db096d49fae6cfb1d58db66"
    sha256 cellar: :any_skip_relocation, monterey:       "dcbc0a6c8d77d36e7640582f9f970f7a73a76850315e3e089d0a6fb304968f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0be84ddf967419068d8f20011bb867c8798b1f543449f0216aaa47b87ca485fd"
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
