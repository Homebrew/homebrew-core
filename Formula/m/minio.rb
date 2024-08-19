class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-08-17T01-24-54Z",
      revision: "72cff79c8a7cc59bccb591995e3c3ed6aa2f4cd5"
  version "20240817012454"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37cf071d3e494044e559a9fa2de3bbb5720686bbeec952588d692f4f7f560f07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f84bc7e61b415d7446a76ec3e4c176f43b96717462923dbb3b01862cb930829e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "717920ec61381d212f08769dba6df5e53f0982e252aba460f7b2b7807aa5dd44"
    sha256 cellar: :any_skip_relocation, sonoma:         "5be6268dd989eefb8a4a31b82f015523d5f03336911de0a2e694205cafdc387a"
    sha256 cellar: :any_skip_relocation, ventura:        "eed454c013ee82e5ab6bb479e7adee3ca62139a22fb94a770c0320b6e1fecdfb"
    sha256 cellar: :any_skip_relocation, monterey:       "7b15219780b156433a56a047a0f0c20bec362f806d00b74ac7cb8014b93e3e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f60fcd97ad54ec5b314e784b153ebee37988dabb0f792c0720e455a2888f627c"
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
