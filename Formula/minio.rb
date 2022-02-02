class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-02-01T18-00-14Z",
      revision: "067d21d0f23254ea9ced107ef1a408fed83964a5"
  version "20220201180014"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6217f9687cfccb054992cf621027ccfd9478747a4d43fb1e52cf199227917e3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00b033292dafcc88eaa24d6b6cb34a753a42b5d07d4d7344154d1f2f5c0cf7a9"
    sha256 cellar: :any_skip_relocation, monterey:       "50ffac7e6b903ddcdb860f2543ad62808b9c19f21144db5e33bf0966a13a181d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9fcab9c47e3e7102d1d0d4d03962c0508e3722efd4f092d330be95f98aef92c"
    sha256 cellar: :any_skip_relocation, catalina:       "1b18b8ba5593f9737d8a001e8356f7344f15d91ca950c55c93e18e1bd8a35879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "898bd01e6b1c34d1c43989817e847ab33bc559c7c285b41fc0051e0737e2e002"
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
