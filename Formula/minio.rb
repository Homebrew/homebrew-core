class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-02-26T02-54-46Z",
      revision: "b7c90751b04e4acd015f3240ad2fa14bac39cf94"
  version "20220226025446"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bb0606eec4c10d60d2098ed1c250422aa705bbb12a748c6ee7ab1110dc3a7fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58714f8d0db22510af9841fad1e5d70ecd8b9e617e82c684d4f9adea545bd30e"
    sha256 cellar: :any_skip_relocation, monterey:       "e6b0c3e3eddb51a5fe1469277116e4132d218ea54d6cccc68983cf7802d6b2d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "86700c21ffaf9c22c083c8dff9b83185ef66e0742831d3644a5a7b5da3f00bf2"
    sha256 cellar: :any_skip_relocation, catalina:       "4238a4b416f7c6d1321a2c6aa2d2d742fd137ff9a11037f24980c1013d4fbc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38eb5e36683b7a144b8284ef6438f50be7e3b5865ba2341530895c296defe8ac"
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
