class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-06-11T19-55-32Z",
      revision: "dd53b287f2eeed9cd3872eeae7d64696bfd7829d"
  version "20220611195532"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b2684d2eb5ec0557fcd1884989ebc1158ebbeae64eaaac6faa0d02e9d67b15a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db40250eae42510c762af204eec81d037c2d833f30c6c79ec930a2cd19f5f4b2"
    sha256 cellar: :any_skip_relocation, monterey:       "08002c7e08f9160e204f9cf65034a90d235c05db8b569fcfdfecefe04c9dee59"
    sha256 cellar: :any_skip_relocation, big_sur:        "fea576f9371e058997d091c52dfe632cd0c56f1faa5fd60af70fb7f7b204b617"
    sha256 cellar: :any_skip_relocation, catalina:       "4957e5f7e2e9a56bf261986a026e8c1ba167cc5c5d9c83e4c62dde5efa4c7d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0708186711a5fdcf8372c9189e7ee0af99aafa96a99efa751516c5c8c755e9"
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
