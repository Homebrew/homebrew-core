class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-06-06T09-36-42Z",
      revision: "5aaef9790ff4d693202ff55bc46b40a1ff67f69e"
  version "20240606093642"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "808060a69b26aaa6ca8750f1bceedfaa59cd13ff0368f896b55d8ca3a713161f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa8109c94e2f828b1802c2224f84c1e0d359e2dce81b7946b131597b3d1cf4a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b60b42cb683f5c178cef4ee21e3c06f85f1e4c45b3ecd8b92d6dc3b11844d325"
    sha256 cellar: :any_skip_relocation, sonoma:         "0903efd3f2b1301ec5a0757270557f23f5c4939979e7add9bfd0e18257c99b1b"
    sha256 cellar: :any_skip_relocation, ventura:        "82fc5e458125f1965c09e1b2d76af59d6b83d518491166195988dbf5a0038848"
    sha256 cellar: :any_skip_relocation, monterey:       "600c9ba0c80baeec6709e974d6012d1070fcdc5dbce827fc9c23291bd3922528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cbaae5f9010143e3f70b0281dc671e692fa1e3a3591d3330ae5b7a22ca37483"
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
