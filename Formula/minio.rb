class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-01-08T03-11-54Z",
      revision: "b7c5e45fff935994791f89237a4891185c55b91f"
  version "20220108031154"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1fcc0c2f06bea207cdb4cc41e2c4980ddb12ba1148e89151ee1813f4f0132c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89100e43f537926d69cd6fa174bf3543734f970ef081dd9b3ebd024b5abfd38e"
    sha256 cellar: :any_skip_relocation, monterey:       "cc4e94cb73438c5249fb092fd5f703d1f3a455a0b8a5873a8349ec887cb1503e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c5c1531243ce5b32fbfa1e239d32b451cc1ff9c89af6138c7cc3b1516568646"
    sha256 cellar: :any_skip_relocation, catalina:       "71a5bd56016152ff877adf39710394a6cdc0efb2cd261508e5d7f012e559f530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b12fe26a0a22dd7940290d344a71a39d3a13724ed3af4c0e5bb2a9a2d05f3f1"
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
