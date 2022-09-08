class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-09-07T22-25-02Z",
      revision: "bb855499e1519f31c03c9b91c0f9f10cb6439253"
  version "20220907222502"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7476eb5decdb8697f863cd4ed7ca4b3fc020860ad1eff94e5f53002fddcd5838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb52158b337809349ce06d1870e4b67f29a2be91d7113273ce58b930b2129c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "489e58d2b0b7a4943ab4618cb9c92c813630a2233e45f3db557b7c1565da4216"
    sha256 cellar: :any_skip_relocation, big_sur:        "d262ba7456b4a7f1c6e38b0bc8bd262ee8b3e5a8ba18e33c4d401d96e540e8d1"
    sha256 cellar: :any_skip_relocation, catalina:       "d4db492319fa8310598bad3eca8ca135a64842fc58ce46c5367d9106423b52a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bd9d90a0cc1183b617931b06f75e88b288c8e9b82079d8ebbf791d01bb5250c"
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
