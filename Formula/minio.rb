class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-04-29T01-27-09Z",
      revision: "0e502899a89fa916094c428c52302330524b2d5e"
  version "20220429012709"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3cb47718348e0fd914fbff9a27e28abb8809cc97b98980a7320709006c6e70a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a45f90874178149efb4ae6516d036ac4faae6b464dcbddba171da17e90ea48ec"
    sha256 cellar: :any_skip_relocation, monterey:       "9aab2d2d73e0334edcad5ea9eb91981224d0a62db97965947cb4da9706a5d7d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "df59c0e3989cc70e6511d4054f24e701cfd09fdda5b11b263e7670d145ac58d1"
    sha256 cellar: :any_skip_relocation, catalina:       "1a1318a28042d49a3af95c8aa3db81d8adbd9c00195647cc40dbd89e8b8c57cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba82cff94fb2a091679501b4ead653f07f3fcbd08c8916e878b37b50b90137d3"
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
