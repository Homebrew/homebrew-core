class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-08T22-28-51Z",
      revision: "46ba15ab03f1bb00743bbecc7fa5661e21044039"
  version "20220308222851"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a3aac2309fc237b80ef7ad601fc3664f565ab47d5fb8c82aa9c58355c07d2dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b27e00f9ef066f8db701e2037abf5b982f09a314a457b9ca18016d8129637e0"
    sha256 cellar: :any_skip_relocation, monterey:       "4f89aee0550e76ae3d002d217bbd8622983e7b83ca601cd1018fa4833a10c23a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a38c972e2638dcb5c959689a81047770bc7c79572e21002d5975f5eb25c95267"
    sha256 cellar: :any_skip_relocation, catalina:       "c8e33bbdc4d059b0055331bd312b7c19fc879d36125cc83b5437af8b44f0aee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39ec635012e5eba115edd04060242d3032522f73137066bf26ab92cd00f1447a"
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
