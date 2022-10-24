class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-10-21T22-37-48Z",
      revision: "86d543d0f667179725fafbc71758d3f881e5cadb"
  version "20221021223748"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0e8ed065bb23683e05dc5b0f92f6b01d4f1e187ed88cd32ed38e8d583fcbe7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd89ddfca580b4bdf7af9132aee402322a3b1fde5edf5ee1164be24958e4fac1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31aaf005fbc78fd4089fb71d13b008b24451757d5ea6c1f272b0c952c4bcbb66"
    sha256 cellar: :any_skip_relocation, monterey:       "23ce53310f6e6957e1da119e9c02e929fdf72c22d0531df675d2fd7ebeca56d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "02097de91647f4c4c95af491961a17025deb8d45bb3120be94eb6b99b47602d2"
    sha256 cellar: :any_skip_relocation, catalina:       "b6466c5cac92336ced561ed30d17806784f81d8d318a97ec895207dfeca55733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55913658735d392fe370d629d239670dab08c3c873c0c01cda7c6985770e423b"
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
