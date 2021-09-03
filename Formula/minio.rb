class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-09-03T03-56-13Z",
      revision: "a19e3bc9d9dd08299229e49081780c79e6cf6a2b"
  version "20210903035613"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29688774bf0f902b2052ae5536a12c3ac227848b1698eceddfbb98858fbb7563"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c92e4887656cb4d601aa150cac08a9b75559a125822f8bb923973c3a7232980"
    sha256 cellar: :any_skip_relocation, catalina:      "79e9cde27b069d30d9734fbd2aaaf58d3004bbda23fc4a82a95630f9b9032fb1"
    sha256 cellar: :any_skip_relocation, mojave:        "db1ee3be7325c34b4aff4a377842968454bfee4a2dce165fc923cb7857f04e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7161700b1e88a8804a11f542a7042728b62cc561339d4684d28db3c14f34138"
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

      system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
