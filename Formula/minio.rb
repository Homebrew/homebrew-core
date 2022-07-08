class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-07-08T00-05-23Z",
      revision: "ed0cbfb31e00644013e6c2073310a2268c04a381"
  version "20220708000523"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "856b2e503d4568ca5c65e64d1882d63d9c83c618f49392903f92bfe873ba2a49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc8db055e55460ff4b7650eadfaf89ffa1ab7b60580c5317a1710973d353e1cf"
    sha256 cellar: :any_skip_relocation, monterey:       "41d4a5366a646728911a77695ee418ed4e3b09c14b469cbd3b2a248f3755c180"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b072fb5848b1b39ae5112e74b5b1d16f359f3b6bd8c5fcc5f225aad2f7b02f7"
    sha256 cellar: :any_skip_relocation, catalina:       "54de783428d0a7a70bd7f3200f966379b013d17b30c2783bcd992dd93c623a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2257e7d1d095a5127f0456b5a81980ec42d3a43839aa1fa3ca012ff3f0df1a6"
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
