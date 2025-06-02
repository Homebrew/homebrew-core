class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-05-24T17-08-30Z",
      revision: "ecde75f9112f8410cb6cacb4b76193f1475b587e"
  version "2025-05-24T17-08-30Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7a99a389dfc166dc25c6011b2ac592e948f54fa2945f89e4630201a79e00285"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8dd242afa2bffa2175f6e66730db2a3cae66768f898e59141040477515a6007"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8534474113b6387ebb7810bffa6c0e7b3c3b2958546844a06337f72c3c7e001"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df8eae2353fe570112ed0857f77489b905d66ebde8a0b4a34b009f259bea364"
    sha256 cellar: :any_skip_relocation, ventura:       "23ddff0c6418742665063f184b78f629dff9fa9a187002b216e127a8169e4f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dcd802f59aa40e0ebcc2c011c0846c7a9da006d4116de1f7ed9119823a33662"
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
