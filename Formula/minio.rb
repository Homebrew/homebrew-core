class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-08-11T04-37-28Z",
      revision: "d265fe7f9ed5ffa1679bcce9e20481a8d9eec73a"
  version "20220811043728"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4462c5e1094206594b6ec98a2473d1bb9e2833e9eae76b12abf8c5726c15a06e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df35727d005e811286f53667efdf2d171af951df741b474a31ed8e3a6255e991"
    sha256 cellar: :any_skip_relocation, monterey:       "9ff6592152083b7bdbbbc12868730592f06965ead8dccf19c5cf7ec3d701880c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd36f340f80d9eafa967093d672debeb8c93c59866f3fd03ea5c8df1be1a4116"
    sha256 cellar: :any_skip_relocation, catalina:       "74901da0671fa6f3a51779ad4954dbb9f12baffebd013ffe1382e52f8dcdf47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1779adf028aa642a3fac015ea20a613fa9068822759c4ccc80d4187dc89b47ae"
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
