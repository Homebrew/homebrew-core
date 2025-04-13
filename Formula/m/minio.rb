class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-04-08T15-41-24Z",
      revision: "d0cada583fce88f60cb276ddfb06f5cb16820069"
  version "2025-04-08T15-41-24Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "655220ea78afa5e8bd5e7824f0c207abd8f732eb1baf6a610c3bfc224202076d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f98ce3de3793661cc0edd433763473c1df3f8717c3fe1dfc97e30f452d6e16c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27fcef21fb7194c8e9a06afa95b1017996aedc80fce3921935b665704f5c61cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2174b5ac9aa783f93babe59b6dc28b58f8aef7a8e21725969ff9d778d1805a0f"
    sha256 cellar: :any_skip_relocation, ventura:       "9dfd7c4609266bb7e3ff1fc1190e5b18d03b96babb7feaf0758d9105ac1a6717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dc88a57ae9cb8e657093b13ca76b81d71c1e80d6fb543aa6615a52dea9b1d88"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{minio_version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{minio_release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
        -X github.com/minio/minio/cmd.CopyrightYear=#{version.major}
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
    output = shell_output("#{bin}/minio --version 2>&1")
    assert_equal version.to_s, output[/(?:RELEASE[._-]?)?([\dTZ-]+)/, 1], "`version` is incorrect"

    output = shell_output("#{bin}/minio server --help 2>&1")
    assert_match "minio server - start object storage server", output
  end
end
