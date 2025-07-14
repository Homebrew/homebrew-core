class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-06-13T11-33-47Z",
      revision: "a6c538c5a113a588d49b4f3af36ae3046cfa5ac6"
  version "2025-06-13T11-33-47Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c9d59b70d7399a2def9cd933e5f462964707392e8b2736f90c9962a2c54130d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0cce7a79c03c376e1eb8eb8dd7c7642c1c7fdd0777080d0d20e5118d9f12ae2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99cdc0803e8bc3b26ea5f0981643db3cf461726970801bf5bc9d7c68065c095b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c641708041937ed68e0551a0166b10fb7ffd9c4b0e931dd7d8a7ff58b4b065"
    sha256 cellar: :any_skip_relocation, ventura:       "cf3d5e10d5bac4a646789396542b87a3b340dba56b4fb73663a0634c65ead408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c90279ca158609c82fccbf00f8093f050488440f062bb11a9c0bf7627b6cd15"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      minio_release = stable.specs[:tag]
      minio_version = version.to_s.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')

      ldflags = %W[
        -s -w
        -X github.com/minio/minio/cmd.Version=#{minio_version}
        -X github.com/minio/minio/cmd.ReleaseTag=#{minio_release}
        -X github.com/minio/minio/cmd.CommitID=#{Utils.git_head}
        -X github.com/minio/minio/cmd.CopyrightYear=#{version.major}
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
    output = shell_output("#{bin}/minio --version 2>&1")
    assert_equal version.to_s, output[/(?:RELEASE[._-]?)?([\dTZ-]+)/, 1], "`version` is incorrect"

    output = shell_output("#{bin}/minio server --help 2>&1")
    assert_match "minio server - start object storage server", output
  end
end
