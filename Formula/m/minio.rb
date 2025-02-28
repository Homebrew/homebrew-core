class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-02-28T09-55-16Z",
      revision: "8c2c92f7afdc8386b000c0cb57ecec2ee1f5bcb0"
  version "20250228095516"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d68f7cffdf816295e553240985dbc0a44460508635852a99c4041f4469734c52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "839c42df3787457af804ae4bdca86fd9fc9d0967ba0f00f0b75d29dd7ed09247"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf1c55d10b00ed42fb31b155fca55657916b8f47b4fc0ae986285d1f439bbc50"
    sha256 cellar: :any_skip_relocation, sonoma:        "bab0d370c7412e67ae223656fa0182d6f90a50802c42228d9bac8428f9bf1be0"
    sha256 cellar: :any_skip_relocation, ventura:       "1fda76db52b07cc345f36a1f1c7900c679acc7c0418339e93a50c424f43462cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0fa6cbbc96954f5dbf57f6d212a50bdacc6abbe0079a7d407b844df33448650"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = stable.specs[:tag]
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
