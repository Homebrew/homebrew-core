class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-02-12T00-51-25Z",
      revision: "e3e0532613699b5c5c51ae9536e90167b9e4d6b9"
  version "20220212005125"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ca838787e4dee21492228c565222feb0147fc78e9d00d94ff7d59dac3d329db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcb81397b651635fc658e76d37c672d014f3c6e5a0ded6431bfde0aad1e4ef06"
    sha256 cellar: :any_skip_relocation, monterey:       "a441c5b77f57d321a2967036d7acb5998ab01ba0af8670d791b9e109db1f5830"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa1af91cbb8ca38cb99eb4544db80f591e8e89daf8b36703e5f26900a6a0b3d4"
    sha256 cellar: :any_skip_relocation, catalina:       "85775078f959db3e11e775b3eacfeae4c22a77d95483e3d01b9830101642fa04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca3d92a4e04cc351719461e8a4f390c0af217816c00f882bafe1a3f0a0be73c2"
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
