class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-03-07T00-43-48Z",
      revision: "3fb0cbc030d46e0eaf6bea2a99565110e3e1d409"
  version "20240307004348"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c8e3544f765e58871fa177170732b36617622a16fe767347234c770ee0b023b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6048ac5f2ac9f65f4c48ea89cbc7736e94e539b8c608134bb46955b7bb458a94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59602c4ac3fee293fcc83a691d83d017477da483d2a40d6f581ce7740dea7ad3"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b2436be4f65b01c592daff6e27c9a5b915aa56cf891a40494c8dfe21b3be551"
    sha256 cellar: :any_skip_relocation, ventura:        "e6bd0d0eb64911433e463128c594e5ee863aa10052c4079c9b25c5f0f34321b7"
    sha256 cellar: :any_skip_relocation, monterey:       "c9133c57840bdd8fd453ae2346bfc2efed5b801c85db7a995e55dd57fe00ad05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6963a6e5002caf5e4cafc92b4a343c34b31f45bb23ad7adb24a25e66f238ab9b"
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
