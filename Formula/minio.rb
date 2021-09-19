class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-09-18T18-09-59Z",
      revision: "829ecb20867dae80a75f9ca8e1e89d7caa892bac"
  version "20210918180959"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ae99e799bd93a7af07dd70ab0fbaa4f15ffb3b684c21e887657fcd8b12f1ece"
    sha256 cellar: :any_skip_relocation, big_sur:       "fdac9b4c4e3dfeca5736577daa4b6297de66e322c1481e46553929f80b012ee1"
    sha256 cellar: :any_skip_relocation, catalina:      "58dac822d774d1d1626a2ee40c4faa599e207b4d9fda814a1affd96708f5cb1c"
    sha256 cellar: :any_skip_relocation, mojave:        "12879f9bdac3fc761eae182eb971f87c6273a915bec9c368f43e7891f0aca5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a39ec12fe150d27911d818320950b22eced255b178c5fb567c36f5161813bb77"
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
