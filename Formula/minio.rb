class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-22T02-05-10Z",
      revision: "f6113264f4fdae30528dfc5f0f5867faf0a667ba"
  version "20220322020510"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6322d112b76f9411bc2d485c4d09ebae6e817133ae7b5985dde72475e340cb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4d0cccb9dd6121dd4d467cf225947c4aade1c286dae3bc9945992b8abe0b74e"
    sha256 cellar: :any_skip_relocation, monterey:       "edb4b3bba5a71a337303247fa5d643b3f09ee2436b6966bf18d9be888b0751b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "89ff42147385d28de40b80294a9d2873fcb04f8b7375f15e4ab78e2d875e904d"
    sha256 cellar: :any_skip_relocation, catalina:       "b86b40ccb53ebb6f045dc2f462dcdab9ca1c8c3269aa2fd99904fd203834e672"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49dcbb627e9ad9d16a449889e5bf4b0cc499b8b89ef7c5ce95f48d7a7175f477"
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
