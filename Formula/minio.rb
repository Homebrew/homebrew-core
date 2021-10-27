class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-10-23T03-28-24Z",
      revision: "9694fa8d3a67ca61f37a94d26c9d210fe6f6c145"
  version "20211023032824"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bebf9f860fa2406655c3c1ea78855553b68ee61a02dc0e9eeac51f83a20b04c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50456ce747943769e2d3abc9d8a6ddfd2762a67209ffb841b661c8731c25f330"
    sha256 cellar: :any_skip_relocation, monterey:       "42ca16e15e6f942adb8feb99b919f9d9076ec3a24a4116936d7bfb05497eb133"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b00c4ed929b2d40f986e3a2d1ef058b53be522f85a3482a6f9ccfe3b28760a2"
    sha256 cellar: :any_skip_relocation, catalina:       "d671bb5b91c367b81647aafa5fbecb750ce8cea9eee4534d7ef3e48911c29166"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8feff82e98ce340bebcc3ebe0a76d51fba9834450c2fc12939f0d6fc6035be32"
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
