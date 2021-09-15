class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-09-09T21-37-07Z",
      revision: "5c448b1b97887974bf7de575394d30f97a445785"
  version "20210909213707"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "27dd82c5009798f7286a079a1527ad64589b84d767e8e706b1d3d4f535f3b33f"
    sha256 cellar: :any_skip_relocation, big_sur:       "0db1792b5a41092293709b288b15ab6c3e7fb04af1157ab30ec6bc91a895fe46"
    sha256 cellar: :any_skip_relocation, catalina:      "327f0ad307b2e749ef3fd82ef56c49f8148493d1838c538c6efcebe598517e91"
    sha256 cellar: :any_skip_relocation, mojave:        "517e4f018babca8d7b265258cbbeee2c388b57937edbb88fb604e7e5124c2553"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f0eedd16c0114926a158a4ad3bcf7a712678d75a63fcf0d7cf98330004bee6c"
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
