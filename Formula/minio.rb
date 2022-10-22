class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-10-21T22-37-48Z",
      revision: "86d543d0f667179725fafbc71758d3f881e5cadb"
  version "20221021223748"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3eca34cec20cf494d05d9db0ac4f9918f6c2765290d1289cd41632218db76659"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08e02f8bb546b74fe08c2e10139d902d8d0474506556367eddf4296d64c72053"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf7a8417dd76da0a866e69cf2959eeef8470ea0a46b000ea5d063eef4e3cdef"
    sha256 cellar: :any_skip_relocation, big_sur:        "39d30671cb436dca487eb7bb495201b91f8e176cb4065b9e177f8470ecb7f43b"
    sha256 cellar: :any_skip_relocation, catalina:       "fcd27d98d75db4f2d7765f6325a19b788bcc5754e60531f11c6b98d2605935f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1a446d8b41895db476874fabccf6e71aa507c8939edc26a0b217501b9ba36c1"
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
