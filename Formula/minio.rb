class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-03T21-21-16Z",
      revision: "0e3bafcc54eedc25600cf6e3e6b666c905d96d6e"
  version "20220303212116"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0696fe627189bb95b153291270f8ddaa46e54f9197e315578b6cac51cf8304a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25a5b84e37863c2cc01dd2c7a48772a40aa6a3038978ad8b10675ce2f5362607"
    sha256 cellar: :any_skip_relocation, monterey:       "75b291aa96685157fae72e87d9b3914887c8512c11938cb31ce9e765a49d2ecd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c841434991369cc5f34465930ba3ca0e8649683e09f7c9090f299c684823f41c"
    sha256 cellar: :any_skip_relocation, catalina:       "0e1244b023481c0367f45211f103e6604ab0eb1341d3a546918543f1edaf48a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89c3cbab2047f106c95dc962267bd9a5e869d855f25b85fde0a963b037a4d4bd"
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
