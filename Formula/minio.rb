class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-06-03T01-40-53Z",
      revision: "61a7434379164c0a2150db8047343e9ec769ae91"
  version "20220603014053"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18c4a5714cf2aeea5c54cc4736b6d340f8965a3170db93a3f9590b0afd1efe9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f6ea198eea7d31ace8c712617113f1d39a42947abc2fd316aea93467ece5b1e"
    sha256 cellar: :any_skip_relocation, monterey:       "079fa65bfaf25167b4e4a20a9ff3193baf167118ab35c0cc78807c0d34330490"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8165ee17c6f371715e61d1111257a0b1f8a246ac8506d4c50f22572b12b569e"
    sha256 cellar: :any_skip_relocation, catalina:       "bca9a82d259a3c9e0d75b155115908c1d8f75c6df0a4127941f0af9477fba8d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "182d621d664f8969b9b52f67c8ea43690b7cd6aaacf7bff3ca6b243c26a3311d"
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

    assert_match "minio gateway - start object storage gateway",
      shell_output("#{bin}/minio gateway 2>&1")
    assert_match "ERROR Unable to validate credentials",
      shell_output("#{bin}/minio gateway s3 2>&1", 1)
  end
end
