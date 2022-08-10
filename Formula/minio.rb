class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-08-08T18-34-09Z",
      revision: "e178c55bc3615311fac283c542055907c3d48410"
  version "20220808183409"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d30ffebb0cb7cbc0cd96ad1deb545a2cdd8b87e28dad5dd4af58f035d4f5517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d4d4118d3410133f6461a50dfdc3b12d4777c6dbfe159216c1452ed772ce2ce"
    sha256 cellar: :any_skip_relocation, monterey:       "e8c762943d76e3fed003f0a1bed82d9ae243f0ef46ac8618296ecbaa1477ad06"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee9ca2c14b3710f8f912202c73f3f4f07653a17ff292f3b8557ec39175638463"
    sha256 cellar: :any_skip_relocation, catalina:       "46ba0e83a3379cf23953c994423483161ba8ec10112df9f7f088aea2c76445d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7409d40f27e0c3c54edbce79c9e1a0d4a202c6270f329f1561103a7b1d1555b"
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
