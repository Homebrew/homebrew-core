class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-12-09T06-19-41Z",
      revision: "83e8da57b8489f700436769488c139bcd0bc6f6e"
  version "20211209061941"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f1146dcd4493d2f78c7fd1847e118329435d9c3d7f78703a434e1ec96d4ba41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24f91f12cc686c45e98cc63ba595c9e9873adcc13865e176a58d9b3f7bfcd769"
    sha256 cellar: :any_skip_relocation, monterey:       "98ed5612d5167a139cc4e74aa0f61c4cdfd6312e4d03b4e9124ffc89ef42cb53"
    sha256 cellar: :any_skip_relocation, big_sur:        "74cd076d269c7324356f8bca808982b2cdf3757c1cac11ba511f4ac66eb96247"
    sha256 cellar: :any_skip_relocation, catalina:       "d6ee8e5bb60902024085439868de8d2b527903f4c36b47f220998cf91d1eede1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6bdb4f45c46dc4e07fb8fb24bf8e7c18474657e4134529924f993f525b00990"
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
