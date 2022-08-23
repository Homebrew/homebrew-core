class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-08-22T23-53-06Z",
      revision: "4155c5b695bf7bebead55d2afd5c5a5c75e81b6c"
  version "20220822235306"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed244445990ea279f12faf75cabd9fd9aa41d0385b8654f6b3c3b09e5c1824dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6499e86ab2aaf8dea4359087be5fcde246ed1464ed8a3a350a4f71fe5a5b1dd"
    sha256 cellar: :any_skip_relocation, monterey:       "a7a769e22277bab595aab90592416ae0a8eb9719731ce3730b400cbf076e20bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3165c2dc8e4148cce25925be15782bc78ea64b46eeffa6ab6485b1058cbdb089"
    sha256 cellar: :any_skip_relocation, catalina:       "0b6386d82014d1cd996368538886036c624024c92c0d41b71381225f6c39b8b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df2a24c4bc68caf46e8daa5e607ad5737162884bb3fd93b575fa0e4594d9dbfe"
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
