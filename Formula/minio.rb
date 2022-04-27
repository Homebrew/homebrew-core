class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-04-26T01-20-24Z",
      revision: "757eaeae9204ee92b74ef2f2da65c59633d85b3c"
  version "20220426012024"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02832ee35b93da9ab5fbc906b679e3dc43b20fa30e6aacec054694a437c9334f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7edcce6eaa01c0130c354d4b0e1b75b31a9ea315cae61d97e20e9820f4c4758f"
    sha256 cellar: :any_skip_relocation, monterey:       "cab5353f52dfb0bfb07be4e00e669c1d0e9c3bbeaced8d1621c7e3a96f9ca5f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a24b25490f2fda275ed91aaecc2e85f27fb1abe5a45929b8d12bb6efc4d9113"
    sha256 cellar: :any_skip_relocation, catalina:       "04597d4163c87f30e8c562a3435dd9476786b9dd49340228066df39b92ca8325"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67c7388487152bedf15ae1c555a6c6a86aef676131eeaefe6cbf5c4552a7211c"
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
