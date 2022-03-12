class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-11T11-08-23Z",
      revision: "5a5e9b8a89827acd7f9d9aba6f7385686361ff73"
  version "20220311110823"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "242e07767462e7580d7fb08ca017de0deb11a135d2e40bccb8d1fd50831c9f13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51a72f7d9db7d5fd9fc81691e1f7302179b022c2fbb532bb68d19487a66679bf"
    sha256 cellar: :any_skip_relocation, monterey:       "8d951bbbbc1ee8aa475adfef0cda0f8a2cf289a49fcd0b4524bef451c9c1c4fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1a0f2465af7eb76e17f5e570068da0fdf5c546114e9d63c70e30563b2ca03d8"
    sha256 cellar: :any_skip_relocation, catalina:       "e77c8dac7ee0f923a3f80e9868ba1dd847e2169305a74db92992eabd0c4aeb15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e8004a575a009ab4bce45584f23e01b0ecc5715b10c914e2f21ba7ffc668549"
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
