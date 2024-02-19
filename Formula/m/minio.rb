class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-02-17T01-15-57Z",
      revision: "b6e98aed0161bb526aaf11fa1672d30eb89dca4b"
  version "20240217011557"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f4537d246976c78a87b5d0080dae61ec9b161d5012def67f44e4e36fb42ef5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32de6c06c4d7dd248c945779ed0b605b92d5f264202ac17202046aa2c4e5adf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d2bcbd35eec55f9c42b87937c67c3e8ff9e57cc0cde7eec7173fa550c39b4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba3f765ecd6cabc6c8957574916340948893dc2f0946c42cc641d85310e4199c"
    sha256 cellar: :any_skip_relocation, ventura:        "dd43482132c64c3ad1898034336dfebdf59e883ae99b0c531a954545a30e18fe"
    sha256 cellar: :any_skip_relocation, monterey:       "180a524b44a539e3e4e6c79ab01b667af7ba485420197a24a4f20acb0549ae2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fa3ce2b4284fd077f48742ddd54b0ad344ee48c3888d2159090fa7c549c2ffd"
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

      system "go", "build", *std_go_args(ldflags: ldflags)
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
