class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-10-15T19-57-03Z",
      revision: "85fc7cea979b8da1689798e1e290847fd6517c55"
  version "20221015195703"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a1332b93f671088ff086e463e16b3b8ddb64fb92d8d22f3ccfabc9d59396eae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55f13ddd7791dfd6e7c73dc1499b122bc288db699e30606892f37f602b5e18b6"
    sha256 cellar: :any_skip_relocation, monterey:       "4b4eaebc60a5defdeae86b48f3922bdbe58ac52e4922a7752110e1d407f7d4a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "a525e985794bd8140c096a290d45d7ea20f74d9f4e1d22457d0266f6a55306d8"
    sha256 cellar: :any_skip_relocation, catalina:       "53a474d7e1a41b256b355087a51827b025df761e67a5cd80ee9aa974545eae70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1953f7e6d6b8fe9a8da3a94b374c268bc525f67cd34db8fb5ee484e6ffd378b"
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
