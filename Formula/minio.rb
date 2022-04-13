class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-04-12T06-55-35Z",
      revision: "e162a055cc29feedfb20e1be1f5402571cb36100"
  version "20220412065535"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ca7425459722d9570a8fa9556fc43e5cddeb1672570eea903c1a2f607a7c168"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce3e39ca9d21650c64b6738548e8da1f66ae4daebb57e6970ef627a311409ed6"
    sha256 cellar: :any_skip_relocation, monterey:       "930000fd62c7b472b284886649b6a4cb8f5c058ad55ec64e004dcfd7b1260c4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "650dcc8708e502806948b1a39426a765bcb1f688b7524ffd50b4db9652fe5f13"
    sha256 cellar: :any_skip_relocation, catalina:       "ff1e15a37f59026a1f50e1dd10fbb8bb03e11b875fb15b3d5fe90b6c731a6972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24210f55e13d40ebc1e393b002e878b23ed16d41f29774e85821cc7f8bf0673c"
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
