class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-01-20T14-49-07Z",
      revision: "827004cd6d3da8f49a5320c94ae74ae128156ed6"
  version "20250120144907"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5301e17f12211f3e9b739f4e21017ec4a2dbde88e6bdc8d9ff46f5a354534612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5ab970692b66108723ec74098e5c85afd1e278f985cab415c364c40f306dd81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7726f026c4ae78f32ef90f319a8b085671c798818c100b475e8573737f9757a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a01633d4c7119b00519907d8cb1656074a8aaf75357b8b5904c9e353be6dbcb"
    sha256 cellar: :any_skip_relocation, ventura:       "a7f27a33d08961d21f6e20542bdec9186f962581b08d2f50cc179f4f0d50ef58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "433ae1e3b10974af601af8819e41226c00354ad01bcfac473bfee8e20c8d3829"
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
