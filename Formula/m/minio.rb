class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2025-09-07T16-13-09Z",
      revision: "07c3a429bfed433e49018cb0f78a52145d4bedeb"
  version "2025-09-07T16-13-09Z"
  license "AGPL-3.0-or-later"
  version_scheme 1
  head "https://github.com/minio/minio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:RELEASE[._-]?)?([\dTZ-]+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de7ad6d6f693b10b89f995407b5609e3dfc01fa7cd8d0aeadaff4fb77bf3be76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35dd4ff3b33265bd1d43f443c24cd59af871dcd450e7f200685882e52cd05112"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "106411052fb5757c41e02f4b5ec1aa24e32ca6c556f1a460cc4522f7a5a37db3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fe50b3e86d618ebef2e1f111abd05f900cdc74f7898de6ef4e9e9497a6b2069"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc1e22b78739448191a582a5f8cab05411eed7cd51895bb7236ed3ec5cd2b790"
    sha256 cellar: :any_skip_relocation, ventura:       "04c0c5c4dc2720e3febb3f8da3508bd29c072416ca42babff5450f15e077068d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ac58a19d020b54cd05cb02187c617aeca18563147d56c6b00ecaacfd1b7e81"
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
