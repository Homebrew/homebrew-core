class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2022-03-03T21-21-16Z",
      revision: "0e3bafcc54eedc25600cf6e3e6b666c905d96d6e"
  version "20220303212116"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "408a5e3b23da8c71c2a6774e46495a73d146c53e3b98e4ce1f911379b890d7c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f9af950a25c55ec0853aba10ba0a82a41ad5786e6117bf654a755256eff6cfb"
    sha256 cellar: :any_skip_relocation, monterey:       "bef7128a46a59c9be0708899800d9d6e29f1ff5094cf8ee41e56848fd870f887"
    sha256 cellar: :any_skip_relocation, big_sur:        "00570ec2ed5e7b193872d5bea15328a2c18f5e9598e5a55c5a4b33f4e48f8dad"
    sha256 cellar: :any_skip_relocation, catalina:       "fbe9910a7029cda6757681e19b02536475adf933a66ec514b09eebede6099eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a58473d30d6e4fc2f94c9b719ede284a632ac6c8dc35941704d424daf2bc323"
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
