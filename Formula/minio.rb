class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-06-30T20-58-09Z",
      revision: "f9a4ad7904905cd92b61306644c1d403686cf68e"
  version "20220630205809"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15460581f168499c440b744ea56eb05d1865a1e1e5d21462965db8cc64b9abbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81c994e7152c6bb55bbbdd6b7a4a98a8883ef66b06c8f198d34f4a33765244db"
    sha256 cellar: :any_skip_relocation, monterey:       "1c042d87803995e6e8f63b9305b6430f6192cf371fbf34d7ccacc8fb3196b5c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "072ab0092f26930f6ac92ab31ac1809d7a8bffd5969110aeab4a1fe26cf2f2c8"
    sha256 cellar: :any_skip_relocation, catalina:       "1ea8ec1a6722c28cd5b3a3a81becd55745148d98193cd2e63b030d928580eb17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5028923b785f81a7f3eba5a750e37aa830963922380e2f37ab730eeb0f3e863f"
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
