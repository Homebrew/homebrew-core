class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-09-01T23-53-36Z",
      revision: "cf52691959f6707337466d8c7d6c774c9ce4c6e6"
  version "20220901235336"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee9535dd6934328db82485dff716634a66aaa7faf31c3b99cdc2efe9bb77bb39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c02cd2519eb6771d34598a4c87f3c828ec70883c755dd7d2b5482f28dc2e020f"
    sha256 cellar: :any_skip_relocation, monterey:       "2be713bf4a219442d409c23f615c5c58afbc002b4f92fdeec162d5be086e043e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d7bb8ef21ba8e6bfd52a7e5b7e80fd5955fb3dd86a1d2909342918b6a81552c"
    sha256 cellar: :any_skip_relocation, catalina:       "9b23d148efa55762e8a55f71b09a99429b72db0d42bd110bf5797c1cafbe94f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa5eac3e4697e6172a1211dee2b6aad29cfa3b183ea207da152db4935f24b9e"
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
