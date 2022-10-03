class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-10-02T19-29-29Z",
      revision: "f696a221af84fcff27266fd934a427d346547b93"
  version "20221002192929"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e20e49cb36a401d698cdf687d55a2e04be1cebc6bcaa8a90d67b24d053d57b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbdcf6ecb4c5eacb21fe43cfdb12d9060c069dd5de10a393ed49ede99e3051d7"
    sha256 cellar: :any_skip_relocation, monterey:       "874ad2ca0f4c29d3ddc39a3424697462e1e4832893d58d0abf1ae4bcd1622b48"
    sha256 cellar: :any_skip_relocation, big_sur:        "82bcdb2f268c55a49d69ffd003e941a300a1cb0b420a7743f98464e8c4baeb80"
    sha256 cellar: :any_skip_relocation, catalina:       "3b0ef7f81c38b125a4bd06318471b87822fe4016b03edd7eb3a89d2be3044e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ab0e21bea4cb1d7ea69b81152e61c5b30cee5f7eed97003ef76f908c120c490"
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
