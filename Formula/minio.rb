class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-11-11T03-44-20Z",
      revision: "bdcb485740ee2cf320c9b331ebd354df5bf6d826"
  version "20221111034420"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e36049c4c4ef98f7fffeeacfdf1be71f8201748be91ee57dc571a0e0bb795d62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b275134a8bf7289f5446302b097b1966ebf1f632785cd5b275af8d0947a47872"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9be04967def8b6c6dfcee43d1e9169852ae588baaae87c4cb3100d60c778ed17"
    sha256 cellar: :any_skip_relocation, monterey:       "247f217889eaf90935330b2bbcbe60b5ec60a2aca0642ffa453ee8219804b8e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "61ded05d916c7bc9ee7e68e62baf9f158eb7dd97130ee77b5bd09a2a0b10701b"
    sha256 cellar: :any_skip_relocation, catalina:       "b296d5271923dc3f47dc5e18df508ae6ff2f7129d89033d357734ca755807409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b1a398d85f06f820beecfef54a78c775d3149cd2127bdc5efcd0a9f5de01a4"
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
