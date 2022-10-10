class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-10-08T20-11-00Z",
      revision: "3c4ef4338fdfba4e2540a602abccc7f0f115c699"
  version "20221008201100"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82aacb1481b4326162788dfc1b2cbc611f65b3976f559267ec744661e8d1fc18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1273d8c408562f999fc2aaacd49879065fd9fed2c4e739879740d6b31332b0e"
    sha256 cellar: :any_skip_relocation, monterey:       "41fbf9cb222aad02cf9b8fc50c0da9bc95accf2ac7b32d794b7c3470b17a6814"
    sha256 cellar: :any_skip_relocation, big_sur:        "72ef5128a75a331efdd52eee2ec82a600aa9c4b588901cce68b3fc501bc65992"
    sha256 cellar: :any_skip_relocation, catalina:       "ffcd971483a12b4c3790d70c324478c62afcc93d60089c0ea83607cc17f03d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0d229d3c58188b843bae0fcf3fa22e3b3e9b2bbbc88ee56bf9ef7023cf85036"
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
