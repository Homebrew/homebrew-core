class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-02-10T18-48-39Z",
      revision: "d0f4cc89a5d0ca45e7ba00fbb7733c2fead3f44e"
  version "20230210184839"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c54cf9807e8953e97773dc9001de7c0e4d30dfac12017b41a848a6d8d30d07e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "601417c66c0a5294e6ed7bc52850d6312cc7c244172d5623f34695f4d10cd6f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "639356a3971104cb26303010d32798d1d6557d1f30555ed6289127fa558e4847"
    sha256 cellar: :any_skip_relocation, ventura:        "5b6116be708f8c13134a9394328a7b76aacdb20782042ebff42d7b9510f25271"
    sha256 cellar: :any_skip_relocation, monterey:       "7d9c6aa74c0cc79fca08a5cf0773c3605d2beed1e83567e7166f44e6dcbcc355"
    sha256 cellar: :any_skip_relocation, big_sur:        "29667d068240fd29e8484bd7989ed51a10160e4f0f01607cb0b366df500ab1ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c361a9b7fa7afb5cb15308d7ea2879873bfe217574136793063f38845ea59ac2"
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
  end
end
