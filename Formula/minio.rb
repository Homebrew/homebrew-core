class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-01-28T02-28-16Z",
      revision: "a4be47d7ad92131febd9c5e4a8e12249557705e1"
  version "20220128022816"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "160c93bec03c5ab917c70d43fad36c6295b378865aa11a04069c4396b22fe5ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a1ce28cd481d54846a1eff29509b749c1274f70a1cc509f798909567144a17c"
    sha256 cellar: :any_skip_relocation, monterey:       "5d19e2d0f4701c8b49aa98cc62bebbf7757de28811e8a04c7f4ee2d5fb5d3926"
    sha256 cellar: :any_skip_relocation, big_sur:        "e576bcd7ef888a5fcf4323f0d30655e6b372c22f81111aeaba0a8048bfbee02c"
    sha256 cellar: :any_skip_relocation, catalina:       "4b90706e4ba6721d0d714d0052b85155e77ca4405a58120686e98e3978f550d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b47b6d95a246b1c8afc8cebbfdd40b29826a683dc1735e622204ef37b26dcda4"
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
