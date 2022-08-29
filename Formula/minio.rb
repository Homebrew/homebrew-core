class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-08-26T19-53-15Z",
      revision: "1f22a16b15c1f8f5a4820d2422733e2182e63646"
  version "20220826195315"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "828a738263c0ba6f2dd8d1c2092c6a59b55ac80340a2f3e955777cc3635b0296"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65ca97b0d4af1416186cac8d79b14ecdf405882838d96c39aa0f2b4671eedd84"
    sha256 cellar: :any_skip_relocation, monterey:       "ceb694daf48f152bc93df298f2cb6f5f174882a33917c171050cdcd518844a24"
    sha256 cellar: :any_skip_relocation, big_sur:        "b072f91d40f95f41dc0d5578101b6ddfa80e0dcaf8e3cbd7166d734512b88ea2"
    sha256 cellar: :any_skip_relocation, catalina:       "f8eefc17a75bac21fc839d3d0be1263abf0edf2b9fc982e78efdf84fa818aac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "642f7f1a07360eb3169cae3a09eec49dc262fbf79b3ff20be0e5df466b14448a"
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
