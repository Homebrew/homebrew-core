class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-12-20T22-07-16Z",
      revision: "526e10a2e032ee0fc4718c79ed0a8294fa5e103a"
  version "20211220220716"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082e7dff5cccdaa850d305ebc0e4ee811412c1d7a83e694139971d2348bd3765"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df60855e502da0ece613960a71c2417d8eb6bfa842b18373ba64c44f328babf5"
    sha256 cellar: :any_skip_relocation, monterey:       "e49d97ddd8ae032b9b3e9652b7db208678b20bf9f666005906e98023fd865adc"
    sha256 cellar: :any_skip_relocation, big_sur:        "64b911d6525eb359b40295acf104edd37f2b03fc9f51b1d77262e269e133f67c"
    sha256 cellar: :any_skip_relocation, catalina:       "b147dd8c87488fbed6ca76c2fc22287ab53f2802dc67ee78cdc94783683560bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d95d26df262458c85ed571cb028d57c0f78bd04984b95be87e1e1138e210967"
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
