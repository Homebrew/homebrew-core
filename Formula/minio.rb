class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-06-07T00-33-41Z",
      revision: "e2d4d097e754dd3df2f0f6c6104bfc88fb943737"
  version "20220607003341"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edaeb95a1067f673042efdde25ecf957593ef971d54d14efb13f62b201811a7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6c05a71a8900aaff895f44e790009859f45b2c6b15bbfcd5c95f5cd5eb5d3c09"
    sha256 cellar: :any_skip_relocation, monterey:       "1f934d2ebb7dc205a39c1d3cd5e9ac689f700f3e2ca1db0d47d6e51b2a6b55e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "091462625acb6271c45d670662e4754729e2a5eb0ccab134ec1027029d51f2c7"
    sha256 cellar: :any_skip_relocation, catalina:       "b010c58812643cb31bd5ecdc17f9e202d490f92c911035c3dc9e6b0da2ea34dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96c9548c6055afbe6b00006e26584917393b88993bcf9984e8a90a54b142220"
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
