class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-10-02T16-31-05Z",
      revision: "75699a3825c8a9a69175664a4a25d52de234dc89"
  version "20211002163105"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a63d516e5dcd8364a5c01d9fa1d7190d631b69300e90b131a4c2c1b29b761b1"
    sha256 cellar: :any_skip_relocation, big_sur:       "072aab94d6cdcbe4e7dc0e3c366ac3936dba24cb8e44d2fb0a93b8f3a6c0b859"
    sha256 cellar: :any_skip_relocation, catalina:      "68c18e338c3fdca8c2fee5f9f09880d5cfd55acd457c56a6c468fcdafa19b662"
    sha256 cellar: :any_skip_relocation, mojave:        "a831cc71e8d6ddf09e2e608eae62b2608c99a67efac61db65b379b3da409f320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2bf33684dc629f46eccc89fca9bca78173df99610bd8c498e2984c706ff294"
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
