class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-10-02T17-50-41Z",
      revision: "ded0b19d97bb9f73f4d78382eb131ff80003e272"
  version "20241002175041"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("TZ-", "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "275829c6350f41083e9bc1a6c3f86f46fb133bfd69397e482e6f386aab5c41d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc5a910b1eade9e2d3090f73bae037909dfca22a32d83a1a08d5ad9c2d543672"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c878eaaa8a96319366fdf975424fae91093e4ae992f66e5dcaba734ef25871bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb6775d750cf6d6d098e48c8a25fedb2a1d56e3f441c84c2dbf92e606afe78d3"
    sha256 cellar: :any_skip_relocation, ventura:       "a3b818ba9b6b698d3e96a25f7f17ad2a8fca30d5bafe8e4dcb41c2c7cc6103c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95dbfd19fac3e35897f1b2d1a6dcf74b2ea08348b50450427e4e464fcb7c1b73"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub("RELEASE.", "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  service do
    run [opt_bin/"minio", "server", "--certs-dir=#{etc}/minio/certs", "--address=:9000", var/"minio"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/minio.log"
    error_log_path var/"log/minio.log"
  end

  test do
    assert_equal version.to_s,
                 shell_output("#{bin}/minio --version 2>&1")
                   .match(/(?:RELEASE[._-]?)?([\dTZ-]+)/)
                   .to_s
                   .gsub(/[^\d]/, ""),
                 "`version` is incorrect"

    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")
  end
end
