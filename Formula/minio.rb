class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-11T23-57-45Z",
      revision: "dda18c28c519a3a466e630a726ce6e03f41e1e99"
  version "20220311235745"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4791619cc481b741454fe59f39357c83961c9552ee2a070e5f203b1adf68b843"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5754df8cc7fbafb44492bfc20b4d51869ccc5132a8b23aff4b308aa2712914d8"
    sha256 cellar: :any_skip_relocation, monterey:       "aee1fe342e55f7c66d0d2b138d349d89dee5a90d332f8e0f5927fcdc2bf8bdfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9236a1803417674eff3552d9e51cf161663d7b86d70397da5cfc5a96856ac3f1"
    sha256 cellar: :any_skip_relocation, catalina:       "d6c64543efb1ed74a22278b81ed052363566d4564dd607d2cec3db3057be66df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46a879f82fff70e01365ace3d2d4fc1b1be35d48a9cc0eeb345a8d8096d6dc44"
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
