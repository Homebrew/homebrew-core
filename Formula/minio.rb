class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-06-02T02-11-04Z",
      revision: "be6ccd129d3e759abaaeb326d9371aa769348771"
  version "20220602021104"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdd8c92ff0af63ba1872beff55661d9b2580fda720710b609234d1480585398a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c751a39173d30e42d961fb1fac1d4c8310472f2854476fdd2ecb1b428115cbf"
    sha256 cellar: :any_skip_relocation, monterey:       "a5cc6dd64dcc46745f8b8fbfe2d12a709ef0a211e8c36309c163d6669308885d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d62a3c1d66ad36415c5c51c3fefb8c2e8cc832ea34e34eb2a9151762d1795e89"
    sha256 cellar: :any_skip_relocation, catalina:       "fd6587d6d4f7ced6201aa24671bd816f80c9b6d6bf819ddbc022f35d8518b4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "774c12e0c186ce3f81f5d3688294cdda870cf487add9abe37d8328c3c8756828"
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
