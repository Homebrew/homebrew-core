class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-01-04T07-41-07Z",
      revision: "d2b6aa90332ee7a0b94024789ef2beb80fb5f515"
  version "20220104074107"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee33c45121b9d2da2bee7b8ba2c9eb8b65d006c45f90d347a30824618ed5d2b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed1f0da2039809e8df830b1689da1a6e74b920651df88e774187eb3d110ba05f"
    sha256 cellar: :any_skip_relocation, monterey:       "62c4c9acadeb1da92e695512f7d5e743d64bf1e32899f8293d5e58927069bdca"
    sha256 cellar: :any_skip_relocation, big_sur:        "c88e1ede439f494f3ef565f0290560bf544b0c44c8afeaf2247fbb344392addf"
    sha256 cellar: :any_skip_relocation, catalina:       "f9d1986971adc6618c823aa8faecbb54b1ade4628673797447df2831fc1cbb01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bedc2a5ec6382c5ba1d055fe6017ad78c1eb28eb0d2aec89c2dc0e770a068e97"
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
