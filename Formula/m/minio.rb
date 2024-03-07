class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-03-07T00-43-48Z",
      revision: "3fb0cbc030d46e0eaf6bea2a99565110e3e1d409"
  version "20240307004348"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4854109569e3bf393cd42afd4000ead23cdb3e5e513af34ee9a3fcf4f5f51dfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fc14c27a3157dd1abc6b1e9853021eba00e1c41ea8038d6be60c5480df4f4d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a50c321814cb4ac411b681735d3b2da50af79147a7cf988b9a41f4b41a2c31f"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fac405830e01d09d0ebbea350297cb78bf09a164a1922427194faa571d41956"
    sha256 cellar: :any_skip_relocation, ventura:        "c88eaa6e6626c73830a991a0954d8946f0c70eaf2b21503085c8dc3b514b81ea"
    sha256 cellar: :any_skip_relocation, monterey:       "6a5646e4ee20697e012931040ad4f24e3caa8851ce8fc38f989966bbab8add8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f53ab7de8c8f5d1f529cc4dbbb0a5fd042f9359d7d90817b7ccf4950629a23f"
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
