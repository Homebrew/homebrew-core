class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-06-20T23-13-45Z",
      revision: "b3ebc69034bff982ca2c1a6ca43afd20838e99d5"
  version "20220620231345"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee72772ab5c83b942a2034498897cb1ca2515f81e2e5225afe4ce99a80963a73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea23cb40a40104c24cb0acd03c16b5a232998facddfa170afcb502815629d581"
    sha256 cellar: :any_skip_relocation, monterey:       "94e4b7cb62e1af49fe72ca71c3ee8c37ca3f5d0369f0737bacd901a516808a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d28e894c9726d3ae2726436225454cdf1494d2cb4041a7506687af0682ae7ad"
    sha256 cellar: :any_skip_relocation, catalina:       "311d9758e1ae967a03a2d8b3cd28b85f5ab0a6b2d54dedacf364bfc981898a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2ecc5214d4334af9aca407839375cac2cf82bbe40eb7a6ecb74e3012cbafa0c"
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
