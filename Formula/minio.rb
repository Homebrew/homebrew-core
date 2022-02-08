class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-02-07T08-17-33Z",
      revision: "186c477f3c2d56ee5b3614de24d3173fa8881fa2"
  version "20220207081733"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e6ddb0c7d921e8efa315235a45b46d0376e611a14dcc0c565d03d49b47f2f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17f6591253ac460fb842ff51b30242f621aa583e2dd96bab02d8a445c98ec6a6"
    sha256 cellar: :any_skip_relocation, monterey:       "bb4d53c12ee8aa6570dea1a1f5963a870414aa6afb0a65b32ba343180b38e165"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa2556e63f9fa379bee6129b74e09fef976da0fdbe4ad40aad58be317650cff4"
    sha256 cellar: :any_skip_relocation, catalina:       "1655b6e8a42bb4d2aac778c67e5e1535a3a5658c8706ce29e697f0175f95c946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "831dc0153d7e453b27b6cfcddb75a8a53de6291e4b5fc6609528c469c139453b"
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
