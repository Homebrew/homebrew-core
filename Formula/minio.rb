class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-08-05T23-27-09Z",
      revision: "1d2ff46a89c72d3e0f64ab621b154b2622bde988"
  version "20220805232709"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d44ec1ae3ec89b4a8110a9da0cfb1a484393a904943898c9c17f46fcf412f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2dc62ee385f1fc7d64634dcdc5428f2af984362e4d65031a1de6c207bb1f272"
    sha256 cellar: :any_skip_relocation, monterey:       "f88d0d1f939fa1ca2e34b31d8f748d54d4d3d2b9892f3b7ee6c4158d91028229"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed8b2c84fcc0a59221465ffb625b2907260875c7862240ee20cf0833a0e08560"
    sha256 cellar: :any_skip_relocation, catalina:       "fc52b7fd159e40e7e2689166f3829b2b166e4b9b20bcc9d741323b1544b2a483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c27b1c1cc9c6f96e72a937b376fb5ce933acba6d2d9aafaa09dc2aacc954f60"
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
