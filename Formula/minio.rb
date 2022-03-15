class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-14T18-25-24Z",
      revision: "e3071157f0b23d005196f91730e899f68fec0120"
  version "20220314182524"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10ed17c8de93c28be21e300197c96646535379808fb6713dbe75f2fa1b9650e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "835b0383cf6ff61bbc658fa453938852a456f08da03dc1a5176c76092d9759fd"
    sha256 cellar: :any_skip_relocation, monterey:       "4ec532dbbc0c49548ec3f64ea6fb291ab1d4de40592f06de19abfd3723559938"
    sha256 cellar: :any_skip_relocation, big_sur:        "7067fbe85618eaa7aaf4b908c8436b5bb8401e9baedd5bb47af382ac18b1b33a"
    sha256 cellar: :any_skip_relocation, catalina:       "fdcac5e4250f121ff5586f390db6d351210f85a9b33fc3f07633c31c6cd12fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42ad3c38362f4a00fe05fe0ff89db02d51e52ff664f228ae5ac64f0ad25c73eb"
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
