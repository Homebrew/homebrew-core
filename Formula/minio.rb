class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-11-11T03-44-20Z",
      revision: "bdcb485740ee2cf320c9b331ebd354df5bf6d826"
  version "20221111034420"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d37c13e84b56d1dfcca0971614f3f5e9475351b3d65177767945c0492a0ff6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7de2877bf5c08b32f8de037fb8b9368bec054150a34ae08c2067bae6fedc8c07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72bf6a9168eaad45fe05d096f59b5854c455389da182e7623d256b967d556f53"
    sha256 cellar: :any_skip_relocation, ventura:        "86154209a0011163c367356bb2c9efe1b5cd14f0f10c4645f077b8758be70cc9"
    sha256 cellar: :any_skip_relocation, monterey:       "a329916bfa475ad5672c186f40c81536674b05ab5e88ae5a201531d1525fbb27"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e3e6d0d1b36d23bf4a9d1c5a1564f2fb957dd47fd9f78db59e7d070e0703682"
    sha256 cellar: :any_skip_relocation, catalina:       "ffb3fb14eae85d38253e644634b35988ab7b3e09d6f9094f8b4109e0af642510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4696578c3b38a1093b3688e644ac80726c230b12040fcbfe267ecd29c353d7e2"
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
  end
end
