class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-03-05T04-48-44Z",
      revision: "1b5f28e99b145b0e3a5d99d1801a9b5cbfbdb091"
  version "20240305044844"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9b633115b6327e3cc2ae620d5f7901b3570814afea93ebd9d344b9794725898"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9e0daf081c5a771a30c0d0a92e8b5a6cf5ee0a5088b3659ac49f849fadeddb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b9046512ff9664ae6235d9676d9c78ea20aed45f0ca3db2d0bc7b6e1d85169d"
    sha256 cellar: :any_skip_relocation, sonoma:         "504eee16c8cf0359e33ceb49e81e3f1af26385f81428204fd26280e631a6eb88"
    sha256 cellar: :any_skip_relocation, ventura:        "a6313209c4be0f7b792dd378abda5138b096d20fc969157cef24068964766223"
    sha256 cellar: :any_skip_relocation, monterey:       "89ad7e4626d86ec3644e1c01e8ddce16111036bed57bb22ac920c3ca24f6e95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ecd2e202fa66ae16ddf98626c09b8bf45feb7fc12f410490c74e75dd8310777"
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
