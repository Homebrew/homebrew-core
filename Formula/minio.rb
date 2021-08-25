class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-08-25T00-41-18Z",
      revision: "f00e8bc107b0e83029e89238330ec02fa85e065d"
  version "20210825004118"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a67e0d242e9f044e3df975971786fc0cfd6f146a3a4d8752ebd51f9920bd79d"
    sha256 cellar: :any_skip_relocation, big_sur:       "30788ee54bb151fa3a546eb602112ee1a86289dfe84913d5d7899d3ead8584a5"
    sha256 cellar: :any_skip_relocation, catalina:      "8189f0a3800ae3005e3aa8a3a1fbe3b9e0c3ad926373db8371c794d58ef4ba15"
    sha256 cellar: :any_skip_relocation, mojave:        "e441607f6e3531e3db856082db9469e41ff76abf8a08163a0354535e81e62069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c341a1b1d422e01bb42494bc0fefcb38fe5bf23fe6f8fe38091c6cdefa2af5b"
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
