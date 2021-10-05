class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-10-02T16-31-05Z",
      revision: "75699a3825c8a9a69175664a4a25d52de234dc89"
  version "20211002163105"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "764169f5bb773f9f9c85e51a560e495db5c6ba3c35ac7e60856fbfb1b832f207"
    sha256 cellar: :any_skip_relocation, big_sur:       "da6af8ccf1453ab1209486b2ed3f0a76e69b5d12d0a796bb8ca7e00510d962e4"
    sha256 cellar: :any_skip_relocation, catalina:      "eef7c7a2575409bb3295aa2abb3021f1f8aff077c3616bb69331ac9aa65b7c9f"
    sha256 cellar: :any_skip_relocation, mojave:        "c88e62f4b9bd672b3a286c424005eb631581c153f368a3cc9f6b444bf67c1ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104b93534d5d34bf835337ef3fb365743ea932c28a00b496aabcd6ffbad76fe8"
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
