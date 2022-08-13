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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65441d8d983270881dd58e8c78f4715ef2ac89c46035209bfbc0ee04c365dd2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77d7ef386cd6901d35a3268a5aed1d7f25f504d5529744d31de62b8be4eabe84"
    sha256 cellar: :any_skip_relocation, monterey:       "03a5f99cf00b8f763e9c11f2f0b7ce0832b9e7060e956d5b50a4502f89d8d7d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "48f79f25b31e45b874ca3ce7496d6ee35ba2465fc51dd908ffdee3aa54571598"
    sha256 cellar: :any_skip_relocation, catalina:       "682c2c268f860c843f5eab54d2ffd3d0feb63d07061c1d31ee3d446922bf7aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a10b64fbda4e429af1327eda0206729862cefbac4a1a014445b05e765343406d"
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
