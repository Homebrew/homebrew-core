class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-01-18T00-31-37Z",
      revision: "4b6eadbd80313711c01039bfa9a05167291a8c50"
  version "20250118003137"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab6b4c931d8f4a28b412faa66cd07269b6bce2d553fd5392f2399f6df6b3483a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbc752ed64c23ad64ec74a81185d0b2ad36303c3712dc00ee23d1f043e2a9a93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0042dc4cc25a8a555dd39dd0d30c233209321b7bcfcd57ed5a485cddddd169bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "e243cc1780326fddde13cc4ce3c98da3553f869233913d0337a2a5b28a645322"
    sha256 cellar: :any_skip_relocation, ventura:       "a9e7a8c5fd0e2c3b4092db53b0d81f35fb66ed8472d1071c5c8417071dda2c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24f937ef64f1594bba1186791b5cf9fba994ffa035ba075c92da674fc334ad4f"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = stable.specs[:tag]
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
