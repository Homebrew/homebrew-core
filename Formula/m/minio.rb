class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2024-03-26T22-10-45Z",
      revision: "8bce123bba10a3880deb490bab219d5807da725a"
  version "20240326221045"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0be6f7a3a0fd27ca6714360dd845080562354e07c5ef6483183906cadcac3d5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e7706be47a3be95549f6b1610704ecf243ead7b58d478761802f17497bc6b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eec794b62946024363d85150f55c8de57bb77558af5e11c6ecade91bddcda18"
    sha256 cellar: :any_skip_relocation, sonoma:         "487c4550f1da3b1fca6332c309f4e3de1a19c31062d0a2978f2d3438aead7d03"
    sha256 cellar: :any_skip_relocation, ventura:        "60ec45efdfda9468f1768ae17a8e2c3a1e5712b74f8a02b1378b1b02602177b8"
    sha256 cellar: :any_skip_relocation, monterey:       "00281d81fff08d929e66f2282bfbdf4c2288ffeec30ced676943d522bc51effc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4969ef62e0cccbc2e3788f6f565d62033ff1e8c9fae29c49a972b6eb8518f8fe"
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
