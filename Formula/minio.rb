class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2023-04-13T03-08-07Z",
      revision: "a42650c065fe22c6a6d3ce526d80c5354d4bceac"
  version "20230413030807"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d982ecdcaba4eb2fcf1f5e05e6bc6efa1218aace3f816f42df518aa9c9cb874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffbce73b560e8a32847bef6b637a06bc85b5b32e9face7e0bacbf3a8126853d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf4056e708fae317ab3e4946dd160bfed44d0572ca59da5e369c9dd3bd902f51"
    sha256 cellar: :any_skip_relocation, ventura:        "2b9a354adf95087b4b89d7e0a0f9b52d4ec0bc9acc72f7ab1421a4431065482b"
    sha256 cellar: :any_skip_relocation, monterey:       "1a9a79bc4850e18f84c6f25cb724e92c96b46e9c61604d1e0933799e7dca908f"
    sha256 cellar: :any_skip_relocation, big_sur:        "95c4621b5bfb6fb63c4ee05dd682510502fa9c80a0395b48771c265a2323892d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "473a96c12f5b2253fe61450bd0129b8599da30c46f07ea8b402547f82c11bfb1"
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
