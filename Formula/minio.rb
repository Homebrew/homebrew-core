class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-06-07T00-33-41Z",
      revision: "e2d4d097e754dd3df2f0f6c6104bfc88fb943737"
  version "20220607003341"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e18153871d4f28cadba02aaf49a03bd2d22fea5113fd00b319d14eacc83e5b59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3423db354e2d3a3759683357be8d0607064f021ad55ccb782d40d838407b414a"
    sha256 cellar: :any_skip_relocation, monterey:       "5672f609c00faf7c82dbf50a562612bcc7eedc0df9fe17fc0a899ac8d251d61c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1340d4848d2163d9b0706208f152f685026484986cf2b6937cf579fce07bce6b"
    sha256 cellar: :any_skip_relocation, catalina:       "76b9dc72f9ba83db8b84ef703bd5d83b6ae962e2fd013684ee51a951b2acc1ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb97d0e83f1a0295dfa05e61eeadf2e2edcf921350100377fd3084babf44fb1b"
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
